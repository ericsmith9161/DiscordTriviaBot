class Question < ApplicationRecord

  def self.ask_question(diff = "EASY")

    good_questions = Question.where('category = ?', diff)
    
    offset = rand(good_questions.count)
    good_questions.offset(offset).first

  end

end