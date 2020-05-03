class PlayersController < ApplicationController

  def index

    if params[:player]
      data = Player.find_by(name: params[:player], server: params[:server])
    else 
      if params[:limit]
        data = Player.select(:name, :score).where(server: params[:server]).order('score DESC').limit(params[:limit])
      else
        data = Player.select(:name, :score).where(server: params[:server]).order('score DESC').limit(5)
      end
    end
    
    if data
      render json: data    
    else
      render json: { error: "No record in db" }
    end
  end

  def create
    @player = Player.new(name: params[:player], server: params[:server])
    if @player.save
        render json: @player
    else
        render json: @player.errors.full_messages, status: 422
    end
  end

  def update
    @player = Player.find_by(id: params[:id])

    new_score = @player.score + params[:value].to_i

    if @player.update(score: new_score)
      render json: @player
    else
      render json: @player.errors.full_messages, status: 422
    end

  end
end 