class ProjectFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project_file, only: %i[ show edit update destroy ]

  # GET /project_files or /project_files.json
  def index
    @project_files = ProjectFile.all
    @progress = ProjectFile.joins(:entries)
                           .select("project_files.name as filename",
                                   "count(nullif(chinese, '')) as draft",
                                   "sum(entries.status) as finished",
                                   "COUNT(*) as total")
                           .group("project_files.id")
                           .order("project_files.id")
                           .to_a.map(&:serializable_hash)
                           .pluck("filename", "draft", "finished", "total")
                           .map { |filename, draft, finished, total|
                             { filename: filename, draft: draft, finished: finished, total: total }
                           }
  end

  # GET /project_files/1 or /project_files/1.json
  def show
    @project_files = ProjectFile.all
    @progress = ProjectFile.joins(:entries)
                           .select("project_files.name as filename",
                                   "count(nullif(chinese, '')) as draft",
                                   "sum(entries.status) as finished",
                                   "COUNT(*) as total")
                           .group("project_files.id")
                           .order("project_files.id")
                           .to_a.map(&:serializable_hash)
                           .pluck("filename", "draft", "finished", "total")
                           .map { |filename, draft, finished, total|
                             { filename: filename, draft: draft, finished: finished, total: total }
                           }
    @entries = @project_file.entries
  end

  # GET /project_files/new
  def new
    @project_file = ProjectFile.new
  end

  # GET /project_files/1/edit
  def edit
  end

  # POST /project_files or /project_files.json
  def create
    @project_file = ProjectFile.new(project_file_params)

    respond_to do |format|
      if @project_file.save
        format.html { redirect_to @project_file, notice: "Project file was successfully created." }
        format.json { render :show, status: :created, location: @project_file }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_files/1 or /project_files/1.json
  def update
    respond_to do |format|
      if @project_file.update(project_file_params)
        format.html { redirect_to @project_file, notice: "Project file was successfully updated." }
        format.json { render :show, status: :ok, location: @project_file }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end
  #
  # # DELETE /project_files/1 or /project_files/1.json
  # def destroy
  #   @project_file.destroy
  #   respond_to do |format|
  #     format.html { redirect_to project_files_url, notice: "Project file was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_project_file
    @project_file = ProjectFile.find_by(name: params[:name]) || ProjectFile.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def project_file_params
    params.fetch(:project_file, {})
  end
end
