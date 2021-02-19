# frozen_string_literal: true

class EntryListComponent < ViewComponent::Base
  def initialize(entries)
    @entries = entries
  end
end
