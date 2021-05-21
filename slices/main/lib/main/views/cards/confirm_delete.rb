# frozen_string_literal: true

module Main
  module Views
    module Cards
      class ConfirmDelete < View::Base
        expose :id
        expose :errors
      end
    end
  end
end
