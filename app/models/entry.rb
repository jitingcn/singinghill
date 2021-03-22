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
end
