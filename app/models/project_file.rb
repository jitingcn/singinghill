class ProjectFile < ApplicationRecord
  enum status: { working: 0, done: 1 }
  has_many :entries
  broadcasts
end
