class UsersController < ApplicationController
  before_action :authenticate_user!, :find_user

  def show
    is_following = current_user.followees.include?(@user)
    render json: @user.as_json(include: { followers: { only: :username }, followees: { only: :username } }).merge(isFollowing: is_following, currentUser: current_user.username)
  end

  def follow
    if current_user != @user
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
  end
end
