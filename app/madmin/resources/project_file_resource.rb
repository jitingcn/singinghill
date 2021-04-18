class ProjectFileResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :name
  attribute :status
  attribute :created_at, form: false
  attribute :updated_at, form: false

  # Associations
  attribute :entries
end
