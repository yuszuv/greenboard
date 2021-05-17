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
        res = yield persist(data)

        Success(res)
      end

      private

      def validate(input)
        contract.(input)
          .to_monad
          .or do |result|
            form = Entities::CardForm.new(id: nil, **result.to_h)
            attacher = result.context[:attacher]

            form.image = attacher.file if attacher

            Failure[
              :validation,
              form,
              result.errors(full: true).to_h.values.flatten
            ]
          end
          .fmap do |result|
            result.to_h.merge(attacher: result.context[:attacher])
          end
      end

      def persist(attacher:, **data)
        Try[ROM::SQL::Error] do
          Try[Shrine::Error] do
            attacher.create_derivatives
            attacher.finalize
            attacher
          end.to_result.or do |x|
            Failure[:storage, x]
          end.fmap do |attacher|
            data
              .merge(
                photos: [{ image_data: attacher.data.to_json }],
                password: encrypt_password(data[:password])
              )
              .then(&repo.method(:create_with_photos))
          end
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
