# frozen_string_literal: true

module Main
  module Operations
    class UpdateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.update',
        repo: 'repositories.card'
      ]

      def call(id:, **params)
        data = yield validate(id, params)
        yield authorize(id, data)
        card = yield persist(id, transform(data.to_h))

        Success(card)
      end

      private

      def validate(id, input)
        contract.(input)
          .to_monad
          .or do |result|
            form = Entities::CardForm.new(id: id.to_i, **parse_image_data(result.to_h))

            Failure[
              :validation,
              form,
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

      def t(*args)
        HanfBrett::Functions[*args]
      end

      def parse_image_data(input)
        t(:map_value,
         :images,
         t(:map_array,
          t(:map_value,
           :image_data,
           t(-> v { JSON.parse(v) }))))
          .(input)
      end

      def transform(data)
        t(:map_value,
          :images,
          t(:map_array,
            t(:map_value, :image_data, t(-> s { JSON.parse(s) }))
              .>>(t(:deep_symbolize_keys))))
          .(data)
      end

      def persist(id, **data)
        Try[ROM::SQL::Error] do
          data
            .merge(
              password: encrypt_password(data[:password])
            )
            .then{ |x| repo.update_with_images(id.to_i, x) }
        end.to_result.or do |x|
          Failure[:db, x]
        end
        # Try[Shrine::Error] { create_versions_and_finalize(attacher) }
        #   .to_result
        #   .or { |x| Failure[:storage, x] }
        #   .bind do |attacher|
        #     Try[ROM::SQL::Error] { update_db(id, data, [attacher].select(&:file)) }
        #     .to_result
        #     .or { |x| Failure[:db, x] }
        #   end
      end

      def encrypt_password(str)
        HanfBrett::Functions[:encrypt_password].(str)
      end

      # def create_versions_and_finalize(attacher)
      #   if attacher.file
      #     attacher.create_derivatives
      #     attacher.finalize
      #   end
      #   attacher
      # end

      # def map_images_data(attachers)
      #   attachers
      #     .map(&:data)
      #     .compact
      #     .map do |d|
      #       { image_data: d.to_json }
      #     end
      # end

      # def update_db(id, data, attachers)
      #   data
      #     .merge(
      #       images: map_images_data(attachers),
      #       password: encrypt_password(data[:password])
      #     )
      #     .then{ |d| repo.update_with_images(id, d) }
      # end
    end
  end
end
