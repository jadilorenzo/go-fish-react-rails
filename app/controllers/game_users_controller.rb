class GameUsersController < ApplicationController
  def create
    game = Game.find(params[:id])
    redirect_to root_path unless game.users.include?(current_user) || game.less_than_max
    if !game.users.include?(current_user)
      game.users << current_user
      game.start
    end
    redirect_to game
  end
end
