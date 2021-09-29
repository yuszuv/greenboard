# frozen_string_literal: true

module Main
  module Operations
    class FetchFormData < HanfBrett::Operation
      include Deps[
        contract: 'contracts.cards.create',
        repo: 'repositories.card'
      ]

      def call(id=nil)
        if id
          from_record(id)
        else
          Success(Entities::CardForm::Empty)
        end
      end

      private

      def from_record(id)
        Try[ROM::SQL::Error] do
          repo.find(id)
        end.to_result.fmap do |card|
          images_data = card.images.map do |image|
            { id: image.id, url: image.image(:thumbnail).url }
          end
          form = Entities::CardForm.new(card.to_h.merge(images: images_data))
          form
        end
      end
    end
  end
end

