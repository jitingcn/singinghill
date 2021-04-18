class EntryResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :status
  attribute :location
  attribute :source
  attribute :english
  attribute :chinese
  attribute :comment
  attribute :created_at, form: false
  attribute :updated_at, form: false
  attribute :narrator_id
  attribute :index

  # Associations
  attribute :user
  attribute :project_file
end
