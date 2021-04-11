# frozen_string_literal: true

class EntryListItemComponent < ViewComponent::Base
  def initialize(entry, active: false)
    @entry = entry
    @active = active
  end
end
