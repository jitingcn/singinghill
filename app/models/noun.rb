class Noun < ApplicationRecord
  has_paper_trail
  belongs_to :user, optional: true

  include MeiliSearch::Rails
  meilisearch do
    attribute %i[source english chinese leixing comment]
  end
end
