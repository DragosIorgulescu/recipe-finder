module RecipeFinder
  module V1
    class Recipes < Grape::API
      resource :recipes do
        desc "Return recipes based on available ingredients"

        params do
          requires :ingredients, type: String, desc: "List of ingredients"
        end

        before do
          # in a serious app, we would add the rack-cors gem 
          # and whitelist the domain(s) allowed to make requests
          header "Access-Control-Allow-Origin", "*"
        end

        get do
          ingredients = params[:ingredients].split(",")
          recipes = Recipe.by_ingredients(ingredients)
          present recipes, with: RecipeFinder::V1::Entities::Recipe
        end
      end
    end
  end
end
