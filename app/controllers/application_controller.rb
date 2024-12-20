class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
      keys: [:username])
  end

  def authenticate_user!(options = {})
    if user_signed_in?
      super(options)
    else
      render json: { errors: ['You need to sign in or sign up before continuing.'] },
        status: :unauthorized
    end
  end
end
