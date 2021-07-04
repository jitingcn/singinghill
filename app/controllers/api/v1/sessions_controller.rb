class Api::V1::SessionsController < Api::V1::BaseController
  def create
    if current_user.nil?
      unauthenticated!
    else
      @user = current_user
      @user.reset_auth_token! if @user.authentication_token.nil?
    end
  end
end
