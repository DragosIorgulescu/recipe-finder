FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    author { Faker::Name.name }
    category { Faker::Food.ethnic_category }
    cook_time { Faker::Number.between(from: 10, to: 120) }
    prep_time { Faker::Number.between(from: 5, to: 60) }
    rating { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
  end
end
