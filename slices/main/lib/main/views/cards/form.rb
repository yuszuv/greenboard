# frozen_string_literal: true

module Main
  module Views
    module Cards
      class Form < View::Base
        expose :form
        expose :errors

        expose :action do |form:|
          form.id ?  "/karte/#{form.id}" : "/karten"
        end

        expose :verb do |form:|
          form.id ? "PATCH" : "POST"
        end
      end
    end
  end
end
