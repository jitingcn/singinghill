# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  def gitlab
    @user = User.from_omniauth(request.env["omniauth.auth"])
    audit! :oauth_gitlab, @user, payload: request.env["omniauth.auth"]
    if @user.persisted?
      set_flash_message(:notice, :success, kind: "GitLab") if is_navigational_format?
      sign_in @user, event: :authentication
      redirect_to request.env["omniauth.origin"] || root_path
    else
      session["devise.gitlab_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
    end
  end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  def failure
    redirect_to root_path
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
