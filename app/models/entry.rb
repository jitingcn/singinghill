class Entry < ApplicationRecord
  enum status: { draft: 0, accept: 1, finished: 2 }
  belongs_to :user, optional: true
  belongs_to :project_file
  after_save :update_associates

  after_update_commit do
    broadcast_replace_to "entry", target: "entry_list_item_#{id}", partial: "entries/entry_list_item", locals: { entry: self }
    broadcast_replace_to "entry", target: "entry_#{id}", partial: "entries/entry", locals: { entry: self }
    # broadcast_replace_to "project_file", target: "project_file_#{project_file.id}_entry_#{id}", partial: "entries/entry_list", locals: { entries: self }
  end

  def update_associates
    project_file.touch if project_file.present?
  end

  def narrator
    Narrator.find_by(narrator_id: narrator_id)
  end

  def hints
    @hints = []
    @nm ||= Natto::MeCab.new(dicdir: "/usr/lib/mecab/dic/mecab-ipadic-neologd")
    @tokens = @nm.parse(source).split("\n").to_a[0...-1].map do |n|
      n = n.split("\t")
      next if n.size == 1
      next if n[1].include?("記号")

      n[0]
    end.compact
    @hints.append @tokens
    @hints.append Noun.where(source: @tokens).pluck("source", "chinese")
    @hints.append Narrator.where(narrator_source: @tokens).pluck("narrator_source", "narrator_chinese")
    @hints
  end

  def history_change
    AuditLog::Log.where(action: "update_entry", record_type: "Entry", record_id: id)
                 .order("id DESC")
                 .pluck(:user_id, :payload, :created_at)
                 .map{ |data| [User.find_by(id: data[0])&.name, data[1]["chinese"], data[2]] }
  end

  def prefix
    [location, narrator_id].map do |i|
      return "" if i.blank?

      "#{i},"
    end.join
  end

  def text
    string = chinese.blank? ? source : chinese
    symbol = 0
    string.chars.map do |char|
      return char if symbol == 1

      case char
      when "{"  # match control symbol start
        symbol = 1
        ""
      when "}"  # match control symbol end
        symbol = 0
        ""
      else
        char.to_fullwidth
      end
    end.join.gsub("\r\n", "CR")
  end
end
