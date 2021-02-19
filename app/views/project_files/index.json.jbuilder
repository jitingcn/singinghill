json.array! @project_files do |project_file|
  # json.partial! "project_files/project_file", project_file: project_file
  json.extract! project_file, :name
  json.extract! @progress[project_file.id - 1], :draft, :finished, :total
end
