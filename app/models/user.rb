class User < ApplicationRecord
  before_create :generate_authentication_token
  has_many :entries

  enum role: { default: 0, admin: 1 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable,
  #        :timeoutable, :trackable
  devise :database_authenticatable, :registerable, :trackable, :omniauthable, omniauth_providers: %i[gitlab]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth["uid"]).first_or_create do |user|
      user.provider = auth.provider
      user.nickname = auth["info"]["username"]
      user.uid = auth["uid"]
      user.email = auth["info"]["email"]
      user.password = Devise.friendly_token[0, 20]
      user.role = "admin" if auth["extra"]["raw_info"]["is_admin"] == true
    end
  end

  def name
    nickname
  end

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break unless User.find_by(authentication_token: authentication_token)
    end
  end

  def reset_auth_token!
    generate_authentication_token
    save
  end

  def self.online
    ids = ActionCable.server.pubsub.redis_connection_for_subscriptions.zrange "online", 0, -1
    where(id: ids)
  end

  def online?
    !ActionCable.server.pubsub.redis_connection_for_subscriptions.zscore("online", id).nil?
  end
end
