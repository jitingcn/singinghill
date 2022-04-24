class ProjectFile < ApplicationRecord
  default_scope -> { order("id") }
  enum status: { working: 0, done: 1 }
  has_many :entries, dependent: :destroy

  after_update_commit do
    broadcast_replace_to "main-app",
                         target: "project_file_#{id}_progress",
                         partial: "project_files/progress",
                         locals: { project_file: instance_of?(ProjectFile) ? self : becomes(ProjectFile) }
  end

  include MeiliSearch::Rails
  meilisearch do
    attribute %i[name title status]
  end

  def to_txt(source: false)
    get_text = source ? ->(entry) { entry.source.to_line } : ->(entry) { entry.text }
    entries.order(:index).map do |entry|
      entry.prefix + get_text[entry]
    end.join("\n\n").concat("\n")
  end

  def progress
    status = entries.group(:status).size
    empty = entries.where(chinese: "").where.not(status: 4).size
    draft = status.fetch("draft", 0) - entries.where(status: 0, chinese: "").size
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

  def display_name
    return name if title.nil?

    "#{name} - #{title}"
  end
end
