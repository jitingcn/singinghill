class User < ApplicationRecord
  before_create :generate_authentication_token
  has_many :entries
  has_many :nouns
  has_one_attached :avatar
  store_accessor :extra, :qq
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

  def set_qq(number = nil)
    if number
      self.qq = number
      save
    elsif self.email.match(/(\d+)@qq.com/)
      self.qq = Regexp.last_match(1)
      save
    end
  end

  def set_avatar_from_qq
    set_qq
    if qq.present?
      avatar.attach(io: URI.parse("https://q1.qlogo.cn/g?b=qq&nk=#{qq}&s=100").open, filename: "#{self.name}.jpg")
    end
  end
end
