class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :cook_time
      t.integer :prep_time
      t.float :rating
      t.string :cuisine
      t.string :category
      t.string :author
      t.string :image

      t.timestamps
    end
  end
end
