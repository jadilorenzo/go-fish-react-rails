class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    redirect_to login_path if !logged_in?
    @my_games = Game.joins(:game_users).where(game_users: {user_id: current_user.id} ).where(finished_at: nil)
    @open_games = Game.where(started_at: nil)
  end

  def new
    @game = Game.new
  end

  def create
    new_params = game_params
    @game = Game.new(new_params)
    if new_params[:bot_count].to_i < (new_params[:player_count].to_i)
      if @game.save
        flash.now[:notice] = 'Game created!'
        @game.users << current_user
        @game.start
        redirect_to @game
      else
        flash.now[:alert] = 'Game cannot be created!'
        render 'new', status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'Too many bots!'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
    return unless @game.go_fish.present?
    redirect_to games_path unless @game.users.include?(current_user)
    @current_player = @game.go_fish.find_by_id(current_user.id)
    if @game.go_fish.over?
      redirect_to game_over_path(@game)
    end
  end

  def over
    @game = Game.find(params[:id])
  end

  def state_for
    game = Game.find(params[:id])
    user_id = params[:user_id]
    render json: game.state_for(user_id)
  end

  def play_round
    puts "play_round_params", play_round_params
    game = Game.find(params[:id])

    game.play_round(
      play_round_params[:rank],
      play_round_params[:askee],
    )



    #   game.users.each do |user|
    #     partial = ApplicationController.render(partial: "games/over_screen", locals: {game: game, user: user})
    #   end
    #   game.users.each do |user|
    #     current_player = game.go_fish.find_by_id(user.id)
    #     partial = ApplicationController.render(partial: "games/game_view", locals: {game: game, current_player: current_player, user: user})
    #     ActionCable.server.broadcast("game_#{params[:id]}_#{user.id}", { game_view: partial })
    #   end
    # end

    unless game.go_fish.over?
      game.users.each do |user|
        if (user.id != play_round_params[:asker])
          pusher_client.trigger "game-#{params[:id]}", "update-#{user.id}", { message: 'Data changed.' }
          puts 'triggered'
        end
      end
    else
      pusher_client.trigger "game-#{params[:id]}", "over", { message: 'Game over.' }
    end

    respond_to do |format|
      format.html { redirect_to game }
      format.json { render json: game.state_for(play_round_params[:asker]) }
    end
  end

  private

  def game_params
    params.require(:game).permit(:name, :player_count, :bot_count)
  end

  def play_round_params
    params.require(:body).permit(:askee, :rank, :asker)
  end
end
