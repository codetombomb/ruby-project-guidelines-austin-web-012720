class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :category_name
      t.integer :api_id
    end
  end
end
