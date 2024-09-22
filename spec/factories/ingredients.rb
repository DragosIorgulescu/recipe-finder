# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#
FactoryBot.define do
  factory :ingredient do
    name { Faker::Food.ingredient }
    recipe
  end
end
