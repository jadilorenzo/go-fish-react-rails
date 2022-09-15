class GameUsersController < ApplicationController
  def create
    game = Game.find(params[:id])
    redirect_to root_path unless game.users.include?(current_user) || game.less_than_max
    if !game.users.include?(current_user)
      game.users << current_user
      game.start
    end
    redirect_to game
    game.users.each do |user|
      current_player = game.go_fish.find_by_id(user.id) if game.go_fish.present?
      partial = ApplicationController.render(partial: "games/game_view", locals: {game: game, current_player: current_player, user: user})
      ActionCable.server.broadcast("game_#{params[:id]}_#{user.id}", { game_view: partial })
    end
  end
end
