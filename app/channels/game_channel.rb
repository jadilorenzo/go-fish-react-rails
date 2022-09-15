# frozen_string_literal: true 

class GameChannel < ApplicationCable::Channel
  def subscribed
    return if params[:id].nil? 
    if params[:user_id].nil?
      stream_from "game_#{params[:id]}"
    else
      stream_from "game_#{params[:id]}_#{params[:user_id]}"
   end
  end
end