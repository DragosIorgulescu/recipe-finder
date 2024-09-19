module RecipeFinder
  module V1
    class Recipes < Grape::API
      resource :recipes do
        desc "Return recipes based on available ingredients"

        params do
          requires :ingredients, type: Array[String], desc: "List of ingredients"
        end

        get do
          recipes = Recipe.by_ingredients(params[:ingredients])
          present recipes, with: RecipeFinder::V1::Entities::Recipe
        end
      end
    end
  end
end
