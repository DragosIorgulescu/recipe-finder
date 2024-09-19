module RecipeFinder
  module V1
    class Base < Grape::API
      version "v1", using: :path
      format :json
      prefix :api

      mount RecipeFinder::V1::Recipes
    end
  end
end
