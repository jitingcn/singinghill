class ProjectFile < ApplicationRecord
  default_scope -> { order("id") }
  enum status: { working: 0, done: 1 }
  has_many :entries

  after_update_commit do
    broadcast_replace_to "main-app",
                         target: "project_file_#{id}_progress",
                         partial: "project_files/progress",
                         locals: { project_file: self.class != ProjectFile ? self.becomes(ProjectFile) : self }
  end

  def to_txt
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

  def page_num(options = {})
    column = options[:by] || :id
    order  = options[:order] || :asc
    per    = options[:per] || self.class.default_per_page

    operator = (order == :asc ? "<=" : ">=")
    (self.class
         .where("#{column} #{operator} ?", read_attribute(column))
         .order("#{column} #{order}").count.to_f / per).ceil
  end
end
