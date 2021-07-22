class ProjectFilesController < ApplicationController
  before_action :authenticate_user!, only: %i[download_all batch_update_entry edit update]
  before_action :set_project_file, only: %i[show edit update destroy]

  # GET /project_files or /project_files.json
  def index
    @file_id = params[:file_id] ? params[:file_id].to_i : project_file_type.first&.id
    @page = if params[:page]
              params[:page]&.to_i
            elsif params[:file_id] && params[:page].nil?
              1
            else
              project_file_type.find(params[:file_id]).page_num
            end
    @total_pages = project_file_type.page(1).total_pages
    @project_files = project_file_type.page(@page)
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

  # goto file with name
  # # GET /projects_files/goto/{file_name}
  def goto
    name = params.permit(:name).fetch(:name)
    @project_files = project_file_type.where("name LIKE ?", "%#{name}%").limit(10)
    respond_to do |format|
      @project_file = @project_files.find_by_name(name)
      if @project_file
        format.html { redirect_to @project_file }
        format.json { render :show, status: :ok, location: @project_file }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @project_files.pluck(:id, :name).as_json }
      end
    end
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
    dir = Dir.mktmpdir("ProjectFile_")
    begin
      ProjectFile.all.order(:id).each do |project_file|
        next if project_file.entries.order(:index).where.not(chinese: "").count.zero?

        File.open("#{dir}/#{project_file.name}", "w", encoding: "UTF-8") do |file|
          file.write(project_file.to_txt)
        end
      end
      file_list = `ls -1d #{dir}/*`.split.join(" ")
      file = "#{Rails.root}/public/tmp/ProjectFile_#{Time.now.to_i}.zip"
      `zip -9 -j #{file} #{file_list}`
      redirect_to file.remove("#{Rails.root}/public"), layout: false
    ensure
      RemoveTmpDirJob.perform_later(dir)
      RemoveTmpDirJob.set(wait: 10.minutes).perform_later(file)
    end
  end

  # POST /project_files/1/batch or /project_files/1/batch.json
  def batch_update_entry
    @project_file = project_file_type.find(params[:project_file_id])
    @status = (params.fetch(:status)[0] if current_user.admin?) || nil
    return render file: "public/404.html", status: :not_found, layout: false if @project_file.nil?

    uploaded_file = params[:uploaded_file]
    return render file: "public/404.html", status: :not_found, layout: false if uploaded_file.nil?

    if uploaded_file.content_type != "text/plain" || uploaded_file.original_filename != @project_file.name ||
       params["uploaded_file"].nil?
      respond_to do |format|
        format.html { redirect_to @project_file, status: :unprocessable_entity }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end

    data = File.open(uploaded_file.tempfile, "r", encoding: "utf-8").read
    data = data.split(/\r\n|(?<!\r)\n/).reject(&:empty?)
    if data.count != @project_file.entries.count
      respond_to do |format|
        format.html { redirect_to @project_file, status: :unprocessable_entity }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end

    entries = @project_file.entries.order(:index)
    data.each_with_index do |line, index|
      entry = entries[index]
      next if entry.status.to_i >= 2

      location, narrator_id = line.scan(/^[-\d]+,[-\d]+,/)[0]&.split(",") || ["", ""]
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
               payload: { message: "从文件批量导入条目，状态变更为#{entry.status}，新文本：#{entry.chinese}" }
      end
    end

    respond_to do |format|
      format.html { redirect_to @project_file, notice: "Project file was successfully updated." }
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
    if params[:filename]&.match(/\d+.evd.txt/)
      @filename = params[:filename].match(/\d+.evd.txt/)[0]
      return @project_file = project_file_type.find_by(name: @filename)
    end

    @project_file = project_file_type.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_file_params
    params.fetch(:project_file, {})
  end

  def project_file_types
    %w[ProjectFile NightConversation GrathmeldConversation CosmosphereRandom GiftInstall]
  end

  def project_file_type
    params[:type].constantize if params[:type].in? project_file_types
  end
end
