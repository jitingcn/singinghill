class Api::V1::ProjectFilesController < Api::V1::BaseController
  before_action :api_authenticate!

  def download_all
    source = params.fetch(:source, "false") == "true"

    render json: { path: ProjectFile.download_all(source) }
  end

end
