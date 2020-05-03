class EditQuestions < ActiveRecord::Migration[5.2]
  def change
    rename_column :questions, :question_text, :text
  end
end
