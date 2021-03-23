# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"

exit unless Dir.exist?("db/Event_JP") && Dir.exist?("db/Event_EN")

event_jp_files = Dir.glob("db/Event_JP/*.txt").sort_by { |el| el.scan(/\d+/)[0].to_i }
event_en_files = Dir.glob("db/Event_EN/*.txt").sort_by { |el| el.scan(/\d+/)[0].to_i }

raise ParseError("File list size miss match") if event_en_files.size != event_jp_files.size

event_jp_files.size.times do |i|
  filename = event_jp_files[i].split("/")[-1]
  puts "handling #{filename}"
  project_file = ProjectFile.find_by(name: filename) || ProjectFile.create(name: filename)
  content_jp = File.open(event_jp_files[i]).readlines.reject!(&:blank?).map { |el| el.remove("\r").remove("\n") }
  content_en = File.open(event_en_files[i]).readlines.reject!(&:blank?).map { |el| el.remove("\r").remove("\n") }
  content_zh = if File.exist?("db/Event_ZH/#{filename}")
                 File.open("db/Event_ZH/#{filename}")
                     .readlines
                     .reject!(&:blank?)
                     .map { |el| el.remove("\r").remove("\n") }
               end || nil
  raise ParseError("File: #{filename} content miss match") if content_jp.size != content_en.size

  content_jp.size.times do |j|
    location, narrator_id = content_jp[j].scan(/^[-\d]+,[-\d]+,/)[0]&.split(",") || ["", ""]
    source = content_jp[j].remove("#{location},#{narrator_id},")
                          .gsub("CR", "\r\n")
                          .gsub(/(?!{)((IM\d{2}|SC\d{2}|1X|VB\d{2}|CS\d{2}|#[01][ A-Za-z0-9_\-!.]+(##)?)+)/) { |w| "{#{w}}" }
    english = content_en[j].remove("#{location},#{narrator_id},")
                           .gsub(/^[-\d]+,[-\d]+,/, "")
                           .gsub("CR", "\r\n")
                           .gsub(/(?!{)((IM\d{2}|SC\d{2}|1X|VB\d{2}|CS\d{2}|#[01][ A-Za-z0-9_\-!.]+(##)?)+)/) { |w| "{#{w}}" }
                           .tr("\uFF01-\uFF5E\u3000\u2019", "\u0021-\u007E\u0020\u0027")
    entry = Entry.find_by(location: location, narrator_id: narrator_id, source: source, project_file_id: project_file.id)
    if entry.nil?
      entry = Entry.create(location: location, narrator_id: narrator_id, source: source, english: english, project_file_id: project_file.id)
    end
    next if content_zh.nil?

    chinese = content_zh[j].remove("#{location},#{narrator_id},")
                           .gsub("CR", "\r\n")
                           .gsub(/(?!{)((IM\d{2}|SC\d{2}|1X|VB\d{2}|CS\d{2}|#[01][ A-Za-z0-9_\-!.]+(##)?)+)/) { |w| "{#{w}}" }
    next unless entry.chinese.blank?

    entry.update(chinese: chinese)
  end
end

if File.exist?("db/narrator.csv")
  csv_text = File.read("db/narrator.csv")
  csv = CSV.parse(csv_text, headers: true)
  csv.each do |row|
    narrator = Narrator.find_or_initialize_by(narrator_id: row["narrator_id"])
    narrator.update(narrator_source: row["narrator_source"] || "", narrator_chinese: row["narrator_chinese"] || "")
  end
end
