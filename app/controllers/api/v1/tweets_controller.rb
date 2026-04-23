class Api::V1::TweetsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    tweets = Tweet.includes(:user).order(created_at: :desc)
    render json: tweets.as_json(include: { user: { only: :username } })
  end

  def create
    tweet = current_user.tweets.build(tweet_params)
    if tweet.save
      render json: tweet, status: :created
    else
      render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    tweet = Tweet.find(params[:id])
    render json: tweet.as_json(include: { user: { only: :username } })
  end

  def destroy
    tweet = current_user.tweets.find(params[:id])
    if tweet.destroy
      head :no_content
    else
      render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end

  def record_not_found
    render json: { errors: ['Record not found'] }, status: :not_found
  end
end
