module EntriesHelper
  def entry_status(entry)
    if entry.status == "finished"
      "完成"
    else
      entry.chinese.empty? ? "空白" : "草稿"
    end
  end
end
