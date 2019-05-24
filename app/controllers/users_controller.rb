class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  before_action :user_params, only: [:update]
  def show
  end

  def update
    @user.update_without_password(user_params)
    redirect_to user_path(current_user.id)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:description)
  end
end
