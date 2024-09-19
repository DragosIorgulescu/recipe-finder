module RecipeFinder
  module V1
    module Entities
      class Ingredient < Grape::Entity
        expose :name
      end
    end
  end
end
