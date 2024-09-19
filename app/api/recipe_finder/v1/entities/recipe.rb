module RecipeFinder
  module V1
    module Entities
      class Recipe < Grape::Entity
        expose :id
        expose :title
        expose :cook_time
        expose :prep_time
        expose :rating
        expose :cuisine
        expose :category
        expose :author
        expose :image
        expose :ingredients, using: RecipeFinder::V1::Entities::Ingredient
      end
    end
  end
end
