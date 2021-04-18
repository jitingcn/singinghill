class ActiveStorage::VariantRecordResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :variation_digest
  attribute :image, index: false

  # Associations
  attribute :blob
end
