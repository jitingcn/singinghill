require "csv"

task import_misc: :environment do
  puts "import misc file"
  if Dir.exist?("#{Rails.root}/data/misc")
    Entry.without_auto_index do
      Dir.glob("#{Rails.root}/data/misc/*.csv").sort.each do |filepath|
        csv_text = File.read(filepath)
        filename = filepath.split("/")[-1]
        project_file = Misc.find_by(name: filename) || Misc.create(name: filename)
        puts "handling #{filename}"
        csv = CSV.parse(csv_text, headers: false)
        csv&.each_with_index do |row, index|
          source = row[2] || ""
          next if source.blank?
          source = source.gsub("CR", "\r\n").gsub(/(?!{)((IM\d{2}|SC\d{2}|1X|VB\d{2}|CS\d{2}|#[01][ A-Za-z0-9_\-\/!.]+(##)?)+)/) { |w| "{#{w}}" }
          location = row[0] || ""
          narrator_id = row[1] || ""

          Entry.find_or_create_by(source: source,
            index: index,
            location: location,
            narrator_id: narrator_id,
            project_file_id: project_file.id)
        end
      end
    end
  end
end
