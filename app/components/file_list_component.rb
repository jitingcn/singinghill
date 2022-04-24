# frozen_string_literal: true
include Pagy::Frontend
class FileListComponent < ViewComponent::Base
  def initialize(project_files, progress, file_id: "", page: 0, frame: "_top", pagy: nil)
    @project_files = project_files
    @progress = progress
    @file_id = file_id
    @page = page
    @frame = frame
    @pagy = pagy
    @total_pages = @pagy&.pages || 1
  end
end
