class ProjectFile < ApplicationRecord
  enum status: { working: 0, done: 1 }
  has_many :entries

  after_update_commit do
    broadcast_replace_to "main-app", target: "project_file_#{id}_progress", partial: "project_files/progress", local: { project_file: self }
  end

  def to_evdtxt
    entries.order(:index).map do |entry|
      entry.prefix + entry.text
    end.join("\n\n").concat("\n")
  end

  def progress
    status = entries.group(:status).count
    empty = entries.where(chinese: "").where.not(status: 4).count
    draft = status.fetch("draft", 0) - entries.where(status: 0, chinese: "").count
    draft = 0 if draft.negative?
    proofreading = status.fetch("accept", 0) + status.fetch("double_check", 0) + status.fetch("final_check", 0)
    finished = status.fetch("finished", 0)
    { filename: name, empty: empty, draft: draft, proofreading: proofreading, finished: finished }
  end
end
