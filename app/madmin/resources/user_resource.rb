class UserResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :email
  attribute :encrypted_password, form: false
  attribute :nickname
  attribute :reset_password_token, form: false
  attribute :reset_password_sent_at, form: false
  attribute :remember_created_at, form: false
  attribute :sign_in_count, form: false
  attribute :current_sign_in_at, form: false
  attribute :last_sign_in_at, form: false
  attribute :current_sign_in_ip, form: false
  attribute :last_sign_in_ip, form: false
  attribute :created_at, form: false
  attribute :updated_at, form: false
  attribute :provider
  attribute :uid
  attribute :role
  attribute :authentication_token

  # Associations
  attribute :entries
  attribute :nouns

  # Uncomment this to customize the display name of records in the admin area.
  # def self.display_name(record)
  #   record.name
  # end

  # Uncomment this to customize the default sort column and direction.
  # def self.default_sort_column
  #   "created_at"
  # end
  #
  # def self.default_sort_direction
  #   "desc"
  # end
end
