class CommentsController < ApplicationController
  # Why: comments change user content, so every comment action requires authentication.
  before_action :authenticate_user!
  before_action :find_tweet
  before_action :find_comment, only: [:destroy]

  def create
    comment = @tweet.comments.build(comment_params)
    comment.user = current_user

    if comment.save
      render json: comment.as_json(include: { user: { only: [:username] } }, only: [:id, :content, :user_id, :created_at]), status: :created
    else
      render json: { error: "Unable to create comment.", messages: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      head :no_content
    else
      render json: { error: "You can only delete your own comments" }, status: :forbidden
    end
  end

  private

  def find_tweet
    @tweet = Tweet.find_by(id: params[:tweet_id])
    return if @tweet

    render json: { error: "Tweet not found" }, status: :not_found
  end

  def find_comment
    @comment = @tweet.comments.find_by(id: params[:id])
    return if @comment

    render json: { error: "Comment not found" }, status: :not_found
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
