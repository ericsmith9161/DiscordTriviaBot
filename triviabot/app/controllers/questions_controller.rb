class QuestionsController < ApplicationController

  # GET /questions?num=5&diff=easy
  def index
    question = Question.ask_question
    render json: question
  end

end

# params[:difficulty]