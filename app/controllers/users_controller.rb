class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create!(params_user)
    if @user.save!
      redirect_to user_path
    else
      render :new
    end
  end

  private

  def params_user
    params.require(:user).permit(:name, :email, :password, :image_url)
  end
end
