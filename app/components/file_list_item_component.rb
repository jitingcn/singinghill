# frozen_string_literal: true

class FileListItemComponent < ViewComponent::Base
  def initialize(project_file:, frame:)
    @project_file = project_file
    @frame = frame
  end

end
