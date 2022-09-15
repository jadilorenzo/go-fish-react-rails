class StaticPagesController < ApplicationController
  def stats
    @win_percentage = GameUser.win_percentage
    @finished_games = GameUser.finished_games_count
    @time_played = GameUser.time_played
    @rival = current_user.get_rival
  end
end
