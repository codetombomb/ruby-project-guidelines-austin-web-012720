class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.text :question 
      t.string :answer
      t.string :category
      t.integer :value
    end
  end
end
