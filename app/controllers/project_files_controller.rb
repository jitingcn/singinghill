class ProjectFilesController < ApplicationController
  before_action :authenticate_user!, only: %i[download_all batch_update_entry edit update]
  before_action :set_project_file, only: %i[show edit update]

  # GET /project_files or /project_files.json
  def index
    @file_id = params[:file_id] ? params[:file_id].to_i : project_file_type.first&.id
    @page = if params[:page]
      params[:page]&.to_i
    elsif params[:file_id].nil? && params[:page].nil?
      1
    else
      project_file_type.find(params[:file_id]).page_num(per: 25)
    end
    @pagy, @project_files = pagy(project_file_type, page: @page, items: 25)
    @frame = params[:frame] || "_top"
  end

  # GET /project_files/1 or /project_files/1.json
  def show
    @file_id = @project_file.id
    @entries = @project_file.entries.order(:index)

    if params[:entry] && @file_id == (entry = Entry.find_by(id: params.fetch(:entry)))&.project_file_id
      @entry = entry
    end

    if @project_file.nil?
      render file: "public/404.html", status: :not_found, layout: false
      return
    end

    @entry ||= @entries.first
  end

  # download single file
  # GET /projects_files/1/output
  def output
    @project_file = project_file_type.find(params[:project_file_id])
    send_data(@project_file.to_txt, filename: @project_file.name)
  end

  # download all project file
  # GET /projects_files/download
  def download_all
    source = params.fetch(:source, "false") == "true"

    redirect_to ProjectFile.download_all(source), layout: false
  end

  # POST /project_files/1/batch or /project_files/1/batch.json
  def batch_update_entry
    @project_file = project_file_type.find(params[:project_file_id])
    @status = (params.fetch(:status)[0] if current_user.admin?) || nil
    render file: "public/404.html", status: :not_found, layout: false and return if @project_file.nil?

    uploaded_file = params[:uploaded_file]
    render file: "public/404.html", status: :not_found, layout: false and return if uploaded_file.nil?

    unless %w[text/plain text/csv application/vnd.ms-excel].include?(uploaded_file.content_type) && uploaded_file.original_filename == @project_file.name
      respond_to do |format|
        flash[:alert] = "文件类型或文件名不匹配"
        format.html { redirect_to @project_file, status: :unprocessable_entity }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end and return
    end

    data = File.open(uploaded_file.tempfile, "r", encoding: "utf-8").read
    data = data.split(/\r\n|(?<!\r)\n/).reject(&:empty?)
    if data.count != @project_file.entries.count
      respond_to do |format|
        flash[:alert] = "文件条目数量不符"
        format.html { redirect_to @project_file, status: :unprocessable_entity }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end and return
    end

    entries = @project_file.entries.order(:index)
    data.each_with_index do |line, index|
      entry = entries[index]
      next if entry.status.to_i >= 2

      location, narrator_id = line.scan(/\A[^,]+,[-\d]+,/)[0]&.split(",") || ["", ""]
      text = line.remove("#{location},#{narrator_id},")
        .gsub("CR", "\r\n")
        .gsub(/(?!{)((IM\d{2}|SC\d{2}|1X|VB\d{2}|CS\d{2}|#[01][ A-Za-z0-9_\-!.]+(##)?)+)/) { |w| "{#{w}}" }
      next unless location == entry.location && narrator_id == entry.narrator_id &&
        text != entry.source && text.to_halfwidth != entry.english && text != entry.chinese && !text.blank?

      entry.chinese = text
      entry.status = @status || 0
      entry.user_id = current_user.id
      if entry.save
        audit! :update_entry, entry,
          payload: {message: "从文件批量导入条目，状态变更为#{entry.status}，新文本：#{entry.chinese}"}
      end
    end

    respond_to do |format|
      format.html { redirect_to @project_file, notice: "文件更新成功" }
      format.json { render :show, status: :ok, location: @project_file }
    end
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
    @project_file = project_file_type.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_file_params
    params.fetch(:project_file, {})
  end

  def project_file_types
    %w[ProjectFile Event NightConversation GrathmeldConversation CosmosphereRandom GiftInstall Misc]
  end

  def project_file_type
    params[:type].constantize if params[:type].in? project_file_types
  end
end
