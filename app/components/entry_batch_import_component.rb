# frozen_string_literal: true

class EntryBatchImportComponent < ViewComponent::Base
  def initialize(project_file:, current_user:)
    @project_file = project_file
    @current_user = current_user
  end

end
