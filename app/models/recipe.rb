# == Schema Information
#
# Table name: recipes
#
#  id         :bigint           not null, primary key
#  author     :string
#  category   :string
#  cook_time  :integer
#  cuisine    :string
#  image      :string
#  prep_time  :integer
#  rating     :float
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Recipe < ApplicationRecord
  has_many :ingredients

  scope :by_ingredients, ->(ing_list) {
    sanitized_terms = ing_list.map { |term| "%#{sanitize_sql_like(term.downcase.strip)}%" }
    match_conditions = sanitized_terms.map { "ingredients.name ILIKE ?" }.join(" OR ")

    Recipe.joins(:ingredients)
          .group("recipes.id")
          .having(
            "COUNT(ingredients.id) = COUNT(CASE WHEN " + match_conditions + " THEN 1 END)",
            *sanitized_terms
      )
  }
end
