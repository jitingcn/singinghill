module ApplicationHelper
  include Pagy::Frontend
  def full_title(page_title = "")
    base_title = t("SingingHill")
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def tailwind_classes_for(flash_type)
    {
      notice: "bg-green-400 border-l-4 border-green-700 text-white",
      error: "bg-red-400 border-l-4 border-red-700 text-black",
      alert: "bg-red-400 border-l-4 border-red-700 text-black"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def status_select_list
    current_user.admin? ? Entry.statuses.keys : Entry.statuses.keys[0..3]
  end
end
