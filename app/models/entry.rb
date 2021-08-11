class Entry < ApplicationRecord
  enum status: { draft: 0, accept: 1, double_check: 2, final_check: 3, finished: 4 }
  belongs_to :user, optional: true
  belongs_to :project_file
  after_save :update_associates

  after_update_commit do
    broadcast_replace_to "main-app", target: "entry_list_item_#{id}",
                                     partial: "entries/entry_list_item",
                                     locals: { entry: self, active: true }
    broadcast_replace_to "main-app", target: "entry_#{id}", partial: "entries/entry", locals: { entry: self }
    broadcast_replace_to "main-app", target: "entry_total_progress", partial: "entries/total_progress"
    # broadcast_replace_to "project_file", target: "project_file_#{project_file.id}_entry_#{id}", partial: "entries/entry_list", locals: { entries: self }
  end

  include MeiliSearch
  meilisearch enqueue: true do
    attribute %i[source english chinese]
    attribute :user do
      user&.name
    end
    attribute :history_change do
      history_change
    end
  end

  def update_associates
    project_file.touch if project_file.present?
  end

  def narrator
    Narrator.find_by(narrator_id: narrator_id)
  end

  # def hints
  #   @hints = []
  #   @nm ||= Natto::MeCab.new(dicdir: "/usr/lib/mecab/dic/mecab-ipadic-neologd")
  #   @tokens = @nm.parse(source).split("\n").to_a[0...-1].map do |n|
  #     n = n.split("\t")
  #     next if n.size == 1
  #     next if n[1].include?("記号")
  #
  #     n[0]
  #   end.compact
  #   @hints.append @tokens
  #   @hints.append Noun.where(source: @tokens).pluck("source", "chinese")
  #   @hints.append Narrator.where(narrator_source: @tokens).pluck("narrator_source", "narrator_chinese")
  #   @hints
  # end

  def humanize_status
    case status
    when "accept"
      "一校"
    when "double_check"
      "二校"
    when "final_check"
      "三校"
    when "finished"
      "完成"
    else
      chinese.empty? ? "空白" : "草稿"
    end
  end

  def history_change(limit: 10)
    AuditLog::Log.where(action: "update_entry", record_type: "Entry", record_id: id)
                 .order("id DESC")
                 .limit(limit)
                 .pluck(:user_id, :payload, :created_at)
                 .map { |data| { user: User.find_by(id: data[0])&.name, data: data[1], time: data[2] } }

  end

  def prefix
    [location, narrator_id].map do |i|
      return "" if i.blank?

      "#{i},"
    end.join
  end

  def text
    string = chinese.blank? ? source : chinese
    string.to_line
  end

  class << self
    def replace_all(source, chinese)
      where(source: source).update_all(chinese: chinese)
    end

    def replace_all_term(search, original, replace)
      where("source ILIKE ?", "%#{search}%").each do |entry|
        entry.chinese = entry.chinese.gsub(original, replace)
        entry.save
      end
    end
  end
end
