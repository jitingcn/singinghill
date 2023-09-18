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
  attribute :versions

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
