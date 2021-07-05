json.array! @entries do |entry|
  json.(entry, :source, :english, :chinese)
  json.file_name entry.project_file.name
  json.file_title entry.project_file.title
  json.link "#{request.protocol}#{request.host_with_port}#{url_for(entry.project_file)}?#{{ entry: entry.id }.to_query}"
end
