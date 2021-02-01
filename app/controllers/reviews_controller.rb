class ReviewsController < ApplicationController

before_action :authenticate_user!, except: [:index]
  before_action :find_location!

  def index
    @reviews = @location.reviews.order(created_at: :desc)
  end

  def create
    @review = @recipe.reviews.new(review_params)
    @review.user_id = current_user.id
    @review.save
  end

  private
 #determines the recipe to attach the coment to
  def find_location!
    @review = Location.find(params[:location_id])
  end

  def review_params
    params.require(:review).permit(:body)
  end
end