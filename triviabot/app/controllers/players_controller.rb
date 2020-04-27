class PlayersController < ApplicationController

  # print out the top players
  # GET /players?player=jaedashson
  # GET /players
  # GET /players?limit=10
  def index

    if params[:player]
      top_players = Player.find_by(name: params[:player])
    else 
      if params[:limit]
        top_players = Player.select(:name, :score).order('score DESC').limit(params[:limit])
      else
        top_players = Player.select(:name, :score).order('score DESC').limit(5)
      end
    end
     
    render json: top_players    
  end

  #  if params.has_key?(:user)
  #           users = User.where("username LIKE '%#{params[:user]}%'")
  #       else
  #           users = User.all
  #       end
  #       render json: users

  # print out queried player
  # GET /players?id=1
  def show
    player = Player.select(:name, :score).where("name LIKE ?", params[:name])
  end

  def create
    @player = Player.new(name: params[:name])
    if @player.save
        render json: @player
    else
        render json: @player.errors.full_messages, status: 422
    end
  end

  
  # Custom route?
  # params[:ids] => [1, 2, 3, 4]
  # params[:value] => 2
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