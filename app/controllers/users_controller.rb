class UsersController < ApplicationController
  before_action :redirect_user, only: [:new, :create]
  before_action :require_user, only: [:edit, :update, :destroy, :profile]

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params) 
    if @user.save 
      session[:user_id] = @user.id 
      redirect_to root_path
    else 
      redirect_to '/signup' 
    end 
  end

  def edit
    @user = User.find(params[:id])
    return redirect_to edit_user_path(current_user) unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    return redirect_to root_path unless @user == current_user

    if @user.update(user_params)
      redirect_to profile_path
    else 
      redirect_to edit_user_path(current_user) 
    end 
  end

  def destroy
    @user = User.find(params[:id])
    return redirect_to edit_user_path(current_user) unless @user == current_user

    @user.destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  def profile
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
