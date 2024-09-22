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
