class AuditLog::LogResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :action
  attribute :payload
  attribute :request
  attribute :created_at, form: false
  attribute :updated_at, form: false

  # Associations
  attribute :user
  attribute :record
end
