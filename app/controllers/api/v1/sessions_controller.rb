class Api::V1::SessionsController < Api::V1::BaseController
  def create
    current_user = authenticate_user!
    if current_user
      @user = current_user
      @user.reset_auth_token! if @user.authentication_token.nil?
    end
  end
end
