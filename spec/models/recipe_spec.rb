require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe '.by_ingredients' do
    let!(:recipe1) { create(:recipe) }
    let!(:recipe2) { create(:recipe) }
    let!(:recipe3) { create(:recipe) }

    before do
      create(:ingredient, recipe: recipe1, name: '1 pound of tomato')
      create(:ingredient, recipe: recipe1, name: '2 onions')
      create(:ingredient, recipe: recipe1, name: '1 cup of minced garlic')

      create(:ingredient, recipe: recipe2, name: '1 pound of tomato')
      create(:ingredient, recipe: recipe2, name: 'an onion')

      create(:ingredient, recipe: recipe3, name: 'half tomato')
      create(:ingredient, recipe: recipe3, name: 'onion')
      create(:ingredient, recipe: recipe3, name: 'garlic')
      create(:ingredient, recipe: recipe3, name: '1 teaspoon of pepper')
    end

    it 'returns recipes that include all or some of the given ingredients' do
      result = Recipe.by_ingredients(%w[tomato onion garlic])
      expect(result).to include(recipe1)
      expect(result).to include(recipe2)
    end

    it 'does not return recipes with additional required ingredients' do
      result = Recipe.by_ingredients(%w[tomato onion garlic])
      expect(result).not_to include(recipe3)
    end
  end
end
