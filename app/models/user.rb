class User < ApplicationRecord
  enum role: { default: 0, admin: 1 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable,
  #        :timeoutable, :trackable
  devise :database_authenticatable, :omniauthable, omniauth_providers: %i[gitlab]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth["extra"]["raw_info"]["user"]["id"]).first_or_create do |user|
      user.provider = auth.provider
      user.nickname = auth["extra"]["raw_info"]["user"]["username"]
      user.uid = auth["extra"]["raw_info"]["user"]["id"]
      user.email = auth["extra"]["raw_info"]["user"]["email"]
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def name
    nickname
  end
end
