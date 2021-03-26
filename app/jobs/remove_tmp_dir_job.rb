class RemoveTmpDirJob < ApplicationJob
  queue_as :default

  def perform(dir)
    FileUtils.remove_entry dir
  end
end
