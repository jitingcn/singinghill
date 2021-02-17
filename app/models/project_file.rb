class ProjectFile < ApplicationRecord
  enum status: { unfinished: 0, finished: 1 }
  has_many :entries
end
