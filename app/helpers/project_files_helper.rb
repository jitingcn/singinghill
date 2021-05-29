module ProjectFilesHelper
  def project_files_index_path(*args)
    url_for({ controller: :project_files, action: :index, type: @project_file.class.to_s }.merge(args[0]))
  end
end
