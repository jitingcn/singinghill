# frozen_string_literal: true

class EntryListComponentReflex < ApplicationReflex
  def batch_update_status(args = {})
    if current_user && (file = ProjectFile.find_by(id: element.dataset[:file_id])) && Entry.statuses.keys.include?(params["status"])
      file.entries.each do |entry|
        if entry.status != params["status"]
          entry.update(status: params["status"], user_id: current_user.id)
          AuditLog.audit!(
            :update_entry,
            entry,
            payload: {message: "条目状态更改为 #{Entry.human_enum_name(:status, entry.status)}"},
            user: current_user
          )
        end
      end
    else
      morph :nothing
    end
  end
end
