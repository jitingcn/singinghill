require "csv"

task :import_narrator do
  if File.exist?("#{Rails.root}/db/narrator.csv")
    csv_text = File.read("#{Rails.root}/db/narrator.csv")
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      narrator = Narrator.find_or_initialize_by(narrator_id: row["narrator_id"])
      narrator.update(narrator_source: row["narrator_source"] || "", narrator_chinese: row["narrator_chinese"] || "")
    end
  end
end
