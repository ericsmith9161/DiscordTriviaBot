class Question < ApplicationRecord
  validates :text, :answer, :value, :category, presence: true

  def self.purge
    ids = Question
      .where("text LIKE '%of the following%' OR text LIKE '%these%'")
      .pluck(:id)
    Question.delete(ids)
  end

  def self.random(diff)
    questions = Question.where('category = ?', diff)
    offset = rand(questions.count)
    questions.offset(offset).first
  end

end