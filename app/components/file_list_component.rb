# frozen_string_literal: true

class FileListComponent < ViewComponent::Base
  def initialize(project_files, progress, file_id: "")
    @project_files = project_files
    @progress = progress
    @file_id = file_id.match?(/\d+.evd.txt/) ? file_id.scan(/\d+/)[0].to_i + 1 : file_id.to_i
  end
end
