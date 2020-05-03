class QuestionsController < ApplicationController

  def index
    question = Question.random(params[:difficulty])
    render json: question
  end

  def destroy
    Question.delete(params[:id])
    render json: { response: "Question deleted" }
  end

end