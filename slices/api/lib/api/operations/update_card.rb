# frozen_string_literal: true

module Api
  module Operations
    class UpdateCard < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.update',
        repo: 'repositories.card',
        mailer: 'application.mailer'
      ]

      def call(id:, **params)
        data = yield validate(params)
        # yield authorize(id, data[:password])
        # card = yield persist(id, transform(data.to_h))
        card = yield persist(id, data.to_h)
        # notify_admin(card)

        Success(card)
      end

      private

      def notify_admin(res)
        mailer.(res.text)
      end

      def validate(input)
        contract.(input)
          .to_monad
          .or do |result|
            Failure[
              :validation,
              result.errors(full: true).to_h
            ]
          end
      end

      def authorize(id, password)
        Try[ROM::SQL::Error] { repo.find(id) }
          .to_result.bind do |card|
            card.password == encrypt_password(password) ?
              Success() :
              Failure[:authorization, { password: ['Das Passwort stimmt nicht'] }]
          end
      end

      # TODO: extract
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
      end

      def encrypt_password(str)
        HanfBrett::Functions[:encrypt_password].(str)
      end
    end
  end
end
