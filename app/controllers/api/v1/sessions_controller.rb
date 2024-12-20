# frozen_string_literal: true

class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_by(email: params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      sign_in(user)
      token = current_token
      response.set_header('Authorization', "Bearer #{token}")
      user = User.find_by(email: params[:user][:email])
      user = User.find_by(email: params[:user][:email])
      render json: {email: user.email, username: user.username, token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def current_token
    request.env['warden-jwt_auth.token']
  end

end
