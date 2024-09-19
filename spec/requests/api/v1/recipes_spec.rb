require 'rails_helper'

RSpec.describe "API V1 Recipes", type: :request do
  describe "GET /api/v1/recipes" do
    let(:recipe1) { create(:recipe, title: "Pasta") }
    let(:recipe2) { create(:recipe, title: "Cake") }

    before do
      create(:ingredient, name: "Flour", recipe: recipe1)
      create(:ingredient, name: "Eggs", recipe: recipe1)
      create(:ingredient, name: "Tomato", recipe: recipe1)

      create(:ingredient, name: "Flour", recipe: recipe2)
      create(:ingredient, name: "Sugar", recipe: recipe2)
      create(:ingredient, name: "Eggs", recipe: recipe2)
    end

    it "returns a 400 Bad Request when no ingredients are specified" do
      get "/api/v1/recipes"

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to include("ingredients is missing")
    end

    it "returns all recipes when all ingredients are specified" do
      get "/api/v1/recipes", params: { ingredients: %w[Flour Eggs Tomato Sugar] }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      expect(json_response.map { |r| r["title"] }).to contain_exactly("Pasta", "Cake")
    end

    it "returns filtered recipes when specific ingredients are specified" do
      get "/api/v1/recipes", params: { ingredients: %w[Flour Sugar] }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response.first["title"]).to eq("Cake")
    end

    it "returns no recipes when ingredients don't match" do
      get "/api/v1/recipes", params: { ingredients: [ "Chocolate" ] }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_empty
    end

    it "includes ingredients in the recipe response" do
      get "/api/v1/recipes", params: { ingredients: [ "Flour" ] }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.first["ingredients"]).to be_an(Array)
      expect(json_response.first["ingredients"].first).to have_key("name")
    end
  end
end
