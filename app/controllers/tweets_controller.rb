class TweetsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_tweet, only: [:show, :destroy]

  def index
    @tweets = Tweet.all.sort_by(&:created_at).reverse
    render json: {tweets: @tweets.to_json(include: { user: { only: :username } }),
    isLoggedIn: user_signed_in?,
    currentUser: current_user&.username
  }
  end

  def show
    render json: @tweet.to_json(include: { user: { only: :username } })
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:notice] = "Tweet was successfully created."
      render json: @tweet.to_json(include: { user: { only: :username } }), status: :created
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @tweet.user == current_user
      @tweet.destroy
      flash[:notice] = "Tweet was successfully deleted."
      head :no_content
    else
      render json: { error: "You can only delete your own tweets" }, status: :forbidden
    end
  end

  private

  def find_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
