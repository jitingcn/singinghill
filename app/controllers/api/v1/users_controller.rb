class Api::V1::UsersController < Api::V1::BaseController
  before_action :api_authenticate!

  def me
    render json: { email: current_user.email, nickname: current_user.nickname }
  end
end
