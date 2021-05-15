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
        contract.(input).to_monad.or do |x|
          Failure[
            :validation,
            Entities::CardForm.new(id: nil, **input),
            x.errors(full: true).to_h.values.flatten
          ]
        end
          .fmap(&:to_h)
      end

      def persist(data)
        Try[ROM::SQL::Error] do
          Try[Shrine::Error] do
            file = data[:image][:tempfile]
            photo = Entities::Photo.new
            photo.image_attacher.attach(file)
            photo.image_derivatives! # generate versions
          end.to_result.or do |x|
            Failure[:storage, x]
          end.fmap do |photo|
            data
              .merge(
                photos: [{ image_data: photo.image_data }],
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
