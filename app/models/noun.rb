class Noun < ApplicationRecord
  belongs_to :user, optional: true
end
