class Api::V1::BaseController < ApplicationController
  # before_action :authenticate_user!, only: %i[]
  # disable the CSRF token
  protect_from_forgery with: :null_session

  # disable cookies (no set-cookies header in response)
  before_action :destroy_session

  # disable the CSRF token
  skip_before_action :verify_authenticity_token

  def destroy_session
    request.session_options[:skip] = true
  end

  def api_error(opts={})
    render json: {}, status: opts[:status]
  end

  def unauthenticated!
    api_error(status: 401)
  end
end
