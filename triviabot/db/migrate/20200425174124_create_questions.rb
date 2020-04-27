class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.text :question_text, null: false
      t.string :answer, null: false
      t.string :category, null: false
      t.integer :value, null: false
    end
  end
end