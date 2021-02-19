json.extract! project_file, :name
json.set! :entries do
  json.array! @entries do |entry|
    json.extract! entry, :status, :location, :source, :english, :chinese, :comment
  end
end
json.url project_file_url(project_file, format: :json)
