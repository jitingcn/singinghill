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
