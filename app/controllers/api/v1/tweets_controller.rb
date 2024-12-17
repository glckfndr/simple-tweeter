class Api::V1::TweetsController < ApplicationController
  def index
    tweets = Tweet.includes(:user).order(created_at: :desc)
    render json: tweets.as_json(include: { user: { only: :username } })
  end

  def create
  end

  def show
  end

  def destroy
  end
end
