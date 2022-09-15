class SessionController < ApplicationController
  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user&.authenticate(params[:user][:password])
      reset_session
      log_in @user 
      flash[:notice] = 'Successfully logged in'
      redirect_to root_path 
    else
      @user = User.new 
      flash.now[:alert] = 'Invalid email or password'
      render 'new', status: :unprocessable_entity
    end
  end

  def delete
    logout
    redirect_to root_path
  end
end
