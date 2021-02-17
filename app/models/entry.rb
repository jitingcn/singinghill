class Entry < ApplicationRecord
  enum status: { unfinished: 0, finished: 1 }
  belongs_to :user, optional: true
  belongs_to :project_file
end
