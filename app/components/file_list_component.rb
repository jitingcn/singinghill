# frozen_string_literal: true

class FileListComponent < ViewComponent::Base
  def initialize(project_files, progress, file_id: "", page: 0, total_pages: 0)
    @project_files = project_files
    @progress = progress
    @file_id = file_id
    @page = page
    @total_pages = total_pages
  end
end
