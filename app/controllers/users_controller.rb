class UsersController < ApplicationController
  before_action :authenticate_user!, :find_user

  def show
    is_following = current_user.followees.include?(@user)
    render json: @user.as_json(include: { followers: { only: :username }, followees: { only: :username } }).merge(isFollowing: is_following, currentUser: current_user.username)
  end

  def follow
    current_user.followees << @user
    render json: { notice: "Successfully followed #{@user.username}.", currentUser: current_user.username }, status: :ok
  end

  def unfollow
    current_user.followees.delete(@user)
    render json: { notice: "Successfully unfollowed #{@user.username}.", currentUser: current_user.username }, status: :ok
  end

  def followees

    followees = @user.followees
    render json: { followees: followees.as_json(only: [:id, :username]) }
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
