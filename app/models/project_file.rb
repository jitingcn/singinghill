class ProjectFile < ApplicationRecord
  enum status: { working: 0, done: 1 }
  has_many :entries
  # broadcasts

  def to_evdtxt
    entries.order("id").map do |entry|
      entry.prefix + entry.text
    end.join("\n\n").concat("\n")
  end
end
