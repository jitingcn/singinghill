require "csv"

task import_grathmeld_conversation: :environment do
  puts "import grathmeld conversation"
  if Dir.exist?("#{Rails.root}/data/grathmeld_conversation")
    Dir.glob("#{Rails.root}/data/grathmeld_conversation/*.csv")
       .sort_by { |el| el.scan(/\d+/)[0].to_i }.each do |filepath|
      csv_text = File.read(filepath)
      filename = filepath.split("/")[-1]
      project_file = GrathmeldConversation.find_by(name: filename) || GrathmeldConversation.create(name: filename)
      puts "handling #{filename}"
      csv = CSV.parse(csv_text, headers: true)
      csv.each_with_index do |row, index|
        source = row["text_jp"]
        source = source.gsub("CR", "\r\n").gsub(/(?!{)((IM\d{2}|SC\d{2}|1X|VB\d{2}|CS\d{2}|#[01][ A-Za-z0-9_\-!.]+(##)?)+)/) { |w| "{#{w}}" }
        english = row.fetch("text_en", "") || ""
        english = english.gsub("CR", "\r\n")
                         .gsub(/(?!{)((IM\d{2}|SC\d{2}|1X|VB\d{2}|CS\d{2}|#[01][ A-Za-z0-9_\-!.]+(##)?)+)/) { |w| "{#{w}}" }
                         .tr("\uFF01-\uFF5E\u3000\u2019", "\u0021-\u007E\u0020\u0027")
        location = row.fetch("id", "") || ""
        narrator_id = row.fetch("narrator", "") || ""

        Entry.find_or_create_by(source: source,
                                english: english,
                                index: index,
                                location: location,
                                narrator_id: narrator_id,
                                project_file_id: project_file.id)
      end
    end
  end
end
