class ReviewsController < ApplicationController
  before_action :set_transfer, only: %i[new create]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params_review)
    @review.transfer_id = @transfer.id
    if @review.save!
      redirect_to home
    else
      render :new
    end
  end

  private

  def set_transfer
    @transfer = Transfer.find(params[:transfer_id])
  end

  def params_review
    params.require(:review).permit(:comment, :rating)
  end
end
