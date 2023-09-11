class ProjectFile < ApplicationRecord
  default_scope -> { order("id") }
  enum status: {working: 0, done: 1}
  has_many :entries, dependent: :destroy

  after_update_commit do
    broadcast_replace_to "main-app",
      target: "project_file_#{id}_progress",
      partial: "project_files/progress",
      locals: {project_file: instance_of?(ProjectFile) ? self : becomes(ProjectFile)}
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
    {filename: name, empty: empty, draft: draft, proofreading: proofreading, finished: finished}
  end

  def page_num(options = {})
    column = options[:by] || :id
    order = options[:order] || :asc
    per = options[:per] || self.class.default_per_page

    operator = ((order == :asc) ? "<=" : ">=")
    (self.class
         .where("#{column} #{operator} ?", read_attribute(column))
         .order("#{column} #{order}").count.to_f / per).ceil
  end

  def display_name
    return name if title.nil?

    "#{name} - #{title}"
  end

  class << self
    def download_all(source = false)
      dir = Dir.mktmpdir("ProjectFile_")
      begin
        all.order(:id).each do |project_file|
          next if project_file.entries.order(:index).where.not(chinese: "").count.zero?

          File.open("#{dir}/#{project_file.name}", "w", encoding: "UTF-8") do |file|
            file.write(project_file.to_txt(source: source))
          end
        end
        file_list = `ls -1d #{dir}/*`.split.join(" ")
        file = "#{Rails.root}/public/tmp/ProjectFile_#{source ? "_source_" : ""}#{Time.now.to_i}.zip"
        `zip -9 -j #{file} #{file_list}`
      ensure
        RemoveTmpDirJob.perform_later(dir)
        RemoveTmpDirJob.set(wait: 10.minutes).perform_later(file)
      end
      file.remove("#{Rails.root}/public")
    end
  end
end
