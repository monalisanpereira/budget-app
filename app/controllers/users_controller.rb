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
      redirect_to signup_path, alert: t('alerts.errors.user_create')
    end 
  end

  def edit
    return redirect_to profile_path if params[:id].present?
  end

  def update
    @user = User.find(params[:id])
    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @user == current_user

    if @user.update(user_params)
      redirect_to profile_path, notice: t('alerts.success.user_update')
    else 
      redirect_to profile_path, alert: t('alerts.errors.user_update')
    end 
  end

  def destroy
    @user = User.find(params[:id])
    return redirect_to profile_path, alert: t('alerts.errors.no_permission') unless @user == current_user

    @user.destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
