# frozen_string_literal: true

module Main
  module Operations
    class CreateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.create',
        repo: 'repositories.card'
      ]

      def call(input)
        data = yield validate(input)
        res = yield persist(transform(data.to_h))

        Success(res)
      end

      private

      def validate(input)
        contract.(input)
          .to_monad
          .or do |result|
            form = Entities::CardForm.new(id: nil, **parse_image_data(result.to_h))

            Failure[
              :validation,
              form,
              result.errors(full: true).to_h.values.flatten
            ]
          end
          # .fmap do |result|
          #   result.to_h.merge(attacher: result.context[:attacher])
          # end
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

      def persist(**data)
        Try[ROM::SQL::Error] do
          data
            .merge(
              password: encrypt_password(data[:password])
            )
            .then(&repo.method(:create_with_images))
        end.to_result.or do |x|
          Failure[:db, x]
        end
      end

      def encrypt_password(str)
        HanfBrett::Functions[:encrypt_password].(str)
      end
    end
  end
end
