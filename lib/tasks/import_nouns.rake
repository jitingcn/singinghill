require "csv"

task import_nouns: :environment do
  if File.exist?("#{Rails.root}/data/nouns.csv")
    csv_text = File.read("#{Rails.root}/data/nouns.csv")
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      next if row["source"].nil?

      noun = Noun.find_or_initialize_by(source: row["source"])
      if !noun.chinese.nil? && !noun.chinese.blank? && (noun.chinese != row.fetch("chinese", ""))
        puts "{#{noun.source}}".ljust(18) + "#{noun.leixing} - #{noun.chinese} ".ljust(40) + "new #{row.fetch("type", "")} - #{row.fetch("chinese", "")}"
      end
      noun.leixing = row.fetch("type", "") || ""
      noun.english = row.fetch("english", "") || ""
      noun.chinese = row.fetch("chinese", "") || ""
      noun.comment = row.fetch("comment", "") || ""
      noun.save
    end
  end
end
