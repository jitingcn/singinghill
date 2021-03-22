ITEMS_PER_PAGE ||= 50

class ProjectFilesController < ApplicationController
  # before_action :authenticate_user!
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
    respond_to do |format|
      format.turbo_stream { redirect_to ProjectFile.first }
      format.html { redirect_to ProjectFile.first }
      format.json { render }
    end
  end

  # GET /project_files/1 or /project_files/1.json
  def show
    @file_id = @project_file.id
    @page = params[:page] ? params[:page].to_i : @file_id / ITEMS_PER_PAGE
    @total_pages = ProjectFile.count / ITEMS_PER_PAGE
    @project_files = ProjectFile.order(:id)
                                .limit(ITEMS_PER_PAGE)
                                .offset(@page * ITEMS_PER_PAGE)
    @progress = @project_files.joins(:entries)
                              .select("project_files.name as filename",
                                      "count(nullif(chinese, '')) - sum(entries.status) as draft",
                                      "sum(entries.status) as finished",
                                      "COUNT(*) as total")
                              .group("project_files.id")
                              .order("project_files.id")
                              .to_a.map(&:serializable_hash)
                              .pluck("filename", "draft", "finished", "total")
                              .map { |filename, draft, finished, total|
                             { filename: filename, draft: draft, finished: finished, total: total }
                           }
    @entries = @project_file.entries.order(:id)
    redirect_to @project_file if @filename
  end

  # GET /project_files/new
  # def new
  #   @project_file = ProjectFile.new
  # end

  # GET /project_files/1/edit
  def edit
  end

  # POST /project_files or /project_files.json
  # def create
  #   @project_file = ProjectFile.new(project_file_params)
  #
  #   respond_to do |format|
  #     if @project_file.save
  #       format.html { redirect_to @project_file, notice: "Project file was successfully created." }
  #       format.json { render :show, status: :created, location: @project_file }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @project_file.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

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
    if params[:filename]&.match(/\d+.evd.txt/)
      @filename = params[:filename].match(/\d+.evd.txt/)[0]
      return @project_file = ProjectFile.find_by(name: @filename)
    end

    @project_file = ProjectFile.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def project_file_params
    params.fetch(:project_file, {})
  end
end
