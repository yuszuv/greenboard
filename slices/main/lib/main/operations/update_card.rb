# frozen_string_literal: true

module Main
  module Operations
    class UpdateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.update',
        repo: 'repositories.card'
      ]

      def call(id:, **params)
        data = yield validate(params)
        yield authorize(id, data)
        card = yield persist(id, data)

        Success(card)
      end

      private

      def validate(input)
        contract.(input)
          .to_monad
          .fmap(&merge_attacher)
          .or do |result|
            form = Entities::CardForm.new(id: nil, **result.to_h)
            attacher = result.context[:attacher]

            # FIXME: use attacher#form_assign
            form.image = attacher.file if attacher

            Failure[
              :validation,
              Entities::CardForm.new(id: nil, **result.to_h),
              result.errors(full: true).to_h.values.flatten
            ]
          end
      end

      def authorize(id, data)
        Try[ROM::SQL::Error] { repo.find(id) }
          .to_result.bind do |card|
            card.password == encrypt_password(data[:password]) ?
              Success() :
              Failure[:authorization, data, ['Das Passwort stimmt nicht']]
          end
      end

      def persist(id, attacher:, **data)
        Try[Shrine::Error] { create_versions_and_finalize(attacher) }
          .to_result
          .or { |x| Failure[:storage, x] }
          .bind do |attacher|
            Try[ROM::SQL::Error] { update_db(id, data, [attacher].select(&:file)) }
            .to_result
            .or { |x| Failure[:db, x] }
          end
      end

      def encrypt_password(str)
        HanfBrett::Functions[:encrypt_password].(str)
      end

      def create_versions_and_finalize(attacher)
        if attacher.file
          attacher.create_derivatives
          attacher.finalize
        end
        attacher
      end

      def map_photos_data(attachers)
        attachers
          .map(&:data)
          .compact
          .map do |d|
            { image_data: d.to_json }
          end
      end

      def update_db(id, data, attachers)
        data
          .merge(
            photos: map_photos_data(attachers),
            password: encrypt_password(data[:password])
          )
          .then{ |d| repo.update_with_photos(id, d) }
      end

      def merge_attacher
        -> (result) { result.to_h.merge(attacher: result.context[:attacher]) }
      end
    end
  end
end
