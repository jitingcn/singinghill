class NarratorResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :narrator_id
  attribute :narrator_source
  attribute :narrator_chinese
  attribute :created_at, form: false
  attribute :updated_at, form: false

  # Associations
end
