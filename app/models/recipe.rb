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
end
