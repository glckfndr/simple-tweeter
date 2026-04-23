class TweetsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_tweet, only: [:destroy, :edit, :update, :like, :unlike, :retweet, :unretweet]

  def index
    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 20).to_i
    page = 1 if page < 1
    per_page = 20 if per_page < 1
    per_page = [per_page, 50].min

    @tweets = Tweet.includes(:retweets, :likes, :user)
                   .order(created_at: :desc)
                   .offset((page - 1) * per_page)
                   .limit(per_page)
    render json: {
      tweets: @tweets.as_json(include: { user: { only: :username }, likes: { only: :user_id }, retweets: { only: :user_id } }),
      isLoggedIn: user_signed_in?,
      currentUser: {name: current_user&.username, id: current_user&.id}
    }

  end

  def edit
    if @tweet.user == current_user
      render json: @tweet.as_json(include: { user: { only: :username } })
    else
      render json: { error: "You can only edit your own tweets" }, status: :forbidden
    end
  end

  def update
    if @tweet.user == current_user
      if @tweet.update(tweet_params)
        flash[:notice] = "Tweet was successfully updated."
        render json: @tweet.as_json(include: { user: { only: :username } }), status: :ok
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "You can only update your own tweets" }, status: :forbidden
    end
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:notice] = "Tweet was successfully created."
      data = @tweet.as_json(include: { user: { only: :username } })
      ActionCable.server.broadcast 'tweets_channel', {tweet: data}
      render json: data, status: :created
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @tweet.user == current_user
      @tweet.destroy
      ActionCable.server.broadcast 'tweets_channel', {delete: @tweet.id}
      flash[:notice] = "Tweet was successfully deleted."
      head :no_content
    else
      render json: { error: "You can only delete your own tweets" }, status: :forbidden
    end
  end

  def like
    if @tweet.user != current_user
      like = @tweet.likes.find_or_create_by(user: current_user)
      if like.persisted?
        render json: { notice: "Tweet was successfully liked." }, status: :ok
      else
        render json: { error: "Unable to like tweet.", messages: like.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "You cannot like your own tweet." }, status: :forbidden
    end
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
      if @tweet.user != current_user
        retweet = @tweet.retweets.create(user: current_user)
        if retweet.persisted?
          render json: { notice: "Tweet was successfully retweeted." }, status: :ok
        else
          render json: { error: "Unable to retweet.", messages: retweet.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "You cannot retweet your own tweet." }, status: :forbidden
      end
    end
  end

  def unretweet
    @tweet.retweets.where(user: current_user).destroy_all
    render json: { notice: "Tweet was successfully unretweeted." }, status: :ok
  end

  private

  def find_tweet
    @tweet = Tweet.find_by(id: params[:id])
    unless @tweet
      render json: { error: "Tweet not found" }, status: :not_found
      return
    end
  end

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
