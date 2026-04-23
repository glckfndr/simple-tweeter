class UsersController < ApplicationController
  before_action :authenticate_user!, :find_user

  def show
    is_following = current_user.followees.include?(@user)

    respond_to do |format|
      # Why: HTML requests must return the SPA shell for client-side profile routing.
      format.html { render 'home/index' }
      format.json do
        render json: {
          id: @user.id,
          username: @user.username,
          followers: @user.followers.pluck(:username),
          followees: @user.followees.pluck(:username),
          isFollowing: is_following,
          currentUser: current_user.username
        }
      end
    end
  end

  def follow
    if current_user != @user
      # Why: follow should be idempotent to handle repeated UI actions safely.
      follow = current_user.followee_relationships.find_or_create_by(followee: @user)
      if follow.persisted?
        notice = follow.previously_new_record? ? "Successfully followed #{@user.username}." : "You are already following #{@user.username}."
        render json: { notice: notice, currentUser: current_user.username }, status: :ok
      else
        render json: { error: "Unable to follow user.", messages: follow.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "You cannot follow yourself." }, status: :forbidden
    end
  end

  def unfollow
    if current_user != @user
      destroyed = current_user.followee_relationships.where(followee: @user).destroy_all.any?
      if destroyed
        render json: { notice: "Successfully unfollowed #{@user.username}.", currentUser: current_user.username }, status: :ok
      else
        render json: { notice: "You are not following #{@user.username}.", currentUser: current_user.username }, status: :ok
      end
    else
      render json: { error: "You cannot unfollow yourself." }, status: :forbidden
    end
  end

  def followees

    followees = @user.followees
    render json: { followees: followees.as_json(only: [:id, :username]) }
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
    return if @user

    render json: { error: "User not found" }, status: :not_found
    return
  end
end
