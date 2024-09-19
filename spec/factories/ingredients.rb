FactoryBot.define do
  factory :ingredient do
    name { Faker::Food.ingredient }
    recipe
  end
end
