task import_translations: :environment do
  Dir.glob("#{Rails.root}/data/Event_ZH/*.evd.txt").each do |path|
    filename = path.split("/")[-1]
    project_file = ProjectFile.find_by(name: filename)
    next unless project_file

    entries = project_file.entries.order(:id)
    next unless entries

    data = File.open(path, "r", encoding: "utf-8").read
    data = data.split(/\r\n|(?<!\r)\n/).reject(&:empty?)
    next unless data.count == project_file.entries.count

    data.each_with_index do |line, index|
      entry = entries[index]
      next if entry.status.to_i >= 2

      location, narrator_id = line.scan(/^[-\d]+,[-\d]+,/)[0]&.split(",") || ["", ""]
      text = line.remove("#{location},#{narrator_id},")
                 .gsub("CR", "\r\n")
                 .gsub(/(?!{)((IM\d{2}|SC\d{2}|1X|VB\d{2}|CS\d{2}|#[01][ A-Za-z0-9_\-\/!.]+(##)?)+)/) { |w| "{#{w}}" }
      next unless location == entry.location && narrator_id == entry.narrator_id &&
                  text != entry.source && text.to_halfwidth != entry.english

      if entry.chinese.blank? && entry.status.to_i < 3 && !text.blank?
        entry.update(chinese: text, status: 1)
        AuditLog.audit!(:update_entry, entry,
                        payload: { message: "系统导入条目，状态变更为#{entry.status}，文本：#{entry.chinese}" })
        next
      end

      if !entry.chinese.blank? && !text.blank? && text != entry.chinese
        AuditLog.audit!(:update_entry_failed, entry,
                        payload: { message: "系统导入条目被拒绝，当前文本#{entry.chinese}，试图导入的文本：#{text}" })
        next
      end

      # next unless !entry.chinese.blank? && !text.blank? && text == entry.chinese && entry.status.zero?
      #
      # entry.update(status: 1)
      # audit! :update_entry, entry,
      #        payload: { message: "系统更新文本状态为#{entry.status}，文本：#{entry.chinese}" }
    end
  end
end


