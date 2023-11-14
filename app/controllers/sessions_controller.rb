class SessionsController < ApplicationController
  before_action :redirect_user, only: [:new, :create]
  before_action :require_user, only: [:destroy]
  
  def new 
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to '/login'
    end 
  end

  def destroy 
    session[:user_id] = nil 
    redirect_to root_path
  end
end
