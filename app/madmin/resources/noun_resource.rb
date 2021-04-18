class NounResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :source
  attribute :english
  attribute :chinese
  attribute :leixing
  attribute :comment
  attribute :created_at, form: false
  attribute :updated_at, form: false

  # Associations
  attribute :user
end
