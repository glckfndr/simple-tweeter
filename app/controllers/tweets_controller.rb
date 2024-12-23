class TweetsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_tweet, only: [:destroy, :edit, :update, :like, :unlike, :retweet, :unretweet]

  def index
    @tweets = Tweet.all.includes(:retweets, :likes, :user).sort_by(&:created_at).reverse
    render json: {
      tweets: @tweets.as_json(include: { user: { only: :username }, likes: { only: :user_id }, retweets: { only: :user_id } }),
      isLoggedIn: user_signed_in?,
      currentUser: current_user&.username,
      currentUserId: current_user&.id
    }

  end

  def edit
    render json: @tweet.as_json(include: { user: { only: :username } })
  end

  def update
    if @tweet.update(tweet_params)
      flash[:notice] = "Tweet was successfully updated."
      render json: @tweet.as_json(include: { user: { only: :username } }), status: :ok
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
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

  def like
    @tweet.likes.create(user: current_user)
    render json: { notice: "Tweet was successfully liked." }, status: :ok
  end

  def unlike
    @tweet.likes.where(user: current_user).destroy_all
    render json: { notice: "Tweet was successfully unliked." }, status: :ok
  end

  def retweet
    existing_retweet = @tweet.retweets.find_by(user: current_user)
    if existing_retweet
      render json: { notice: "You have already retweeted this tweet." }, status: :ok
    else
      retweet = @tweet.retweets.create(user: current_user)
      if retweet.persisted?
        render json: { notice: "Tweet was successfully retweeted." }, status: :ok
      else
        render json: { error: "Unable to retweet.", messages: retweet.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def unretweet
    @tweet.retweets.where(user: current_user).destroy_all
    render json: { notice: "Tweet was successfully unretweeted." }, status: :ok
  end

  private

  def find_tweet
    @tweet = Tweet.find(params[:id])
    render json: { error: "Tweet not found" }, status: :not_found unless @tweet
  end

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
