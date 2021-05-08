module Main
  module Repositories
    class Card < Repository[:cards]
      commands :create
    end
  end
end
