# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'json'

file_path = Rails.root.join('db', 'recipes-en.json')
recipes_data = JSON.parse(File.read(file_path))

seeded_recipes_count = 0
seeded_ingredients_count = 0
recipes_data.each_batch(batch_size:) do |recipe_data|
  next if Recipe.exists?(title: recipe_data['title'])

  recipe = Recipe.create!(
    title: recipe_data['title'],
    cook_time: recipe_data['cook_time'],
    prep_time: recipe_data['prep_time'],
    rating: recipe_data['ratings'],
    cuisine: recipe_data['cuisine'],
    category: recipe_data['category'],
    author: recipe_data['author'],
    image: recipe_data['image']
  )

  seeded_recipes_count += 1
  puts "Created <#{recipe.title}> recipe"

  recipe_data['ingredients'].each do |ingredient_name|
    next if recipe.ingredients.exists?(name: ingredient_name)
    ingredient = recipe.ingredients.create!(name: ingredient_name)

    seeded_ingredients_count += 1
    puts "Created <#{ingredient.name}> ingredient for <#{recipe.title}> recipe"
  end
end

puts "Seeded #{seeded_recipes_count} recipes and #{seeded_ingredients_count} ingredients."
