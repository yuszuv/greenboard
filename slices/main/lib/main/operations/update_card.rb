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
          .fmap do |result|
            result.to_h.merge(attacher: result.context[:attacher])
          end
          .or do |result|
            form = Entities::CardForm.new(id: nil, **result.to_h)
            attacher = result.context[:attacher]

            form.image = attacher.file if attacher

            Failure[
              :validation,
              Entities::CardForm.new(id: nil, **result.to_h),
              result.errors(full: true).to_h.values.flatten
            ]
          end
      end

      def persist(id, attacher:, **data)
        Try[Shrine::Error] do
          if attacher.file
            attacher.create_derivatives
            attacher.finalize
          end
          attacher
        end.to_result.or do |x|
          Failure[:storage, x]
        end.bind do |attacher|
          Try[ROM::SQL::Error] do
            photos_data = [attacher]
              .map(&:data)
              .compact
              .map do |d|
                { image_data: d.to_json }
              end

            data
              .merge(
                photos: photos_data,
                password: encrypt_password(data[:password])
              )
              .then{ |d| repo.update_with_photos(id, d) }
          end.to_result.or do |x|
            Failure[:db, x]
          end
        end
      end

      def encrypt_password(str)
        HanfBrett::Functions[:encrypt_password].(str)
      end

      def authorize(id, data)
        Try[ROM::SQL::Error] do
          repo.find(id)
        end.to_result.bind do |card|
          card.password == encrypt_password(data[:password]) ? Success() : Failure[:authorization, data, ['Das Passwort stimmt nicht']]
        end
      end
    end
  end
end
