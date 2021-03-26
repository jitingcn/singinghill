# frozen_string_literal: true

class FileListItemComponent < ViewComponent::Base
  def initialize(project_file:)
    @project_file = project_file
  end

end
