class Api::V1::ApplicationController < ApplicationController
  # Why: API clients expect JSON 401, not an HTML redirect, when the JWT is missing or invalid.
  def authenticate_user!(*args)
    unless current_user
      render json: { errors: ['Unauthorized'] }, status: :unauthorized
    end
  end
end
