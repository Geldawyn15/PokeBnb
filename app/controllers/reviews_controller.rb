class ReviewsController < ApplicationController
  before_action :set_transfer, only: %i[new create]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params_review)
    @review.transfer_id = @transfer
    if @review.save!
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  private

  def set_transfer
    @transfer = Transfer.find(params[:transfer_id])
  end

  def params_pokemon
    params.require(:pokemon).permit(:name, :poke_type, :anime_url, :image_url, :level)
  end
end
