class CreateIngredients < ActiveRecord::Migration[7.2]
  def change
    create_table :ingredients do |t|
      t.bigint :recipe_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
