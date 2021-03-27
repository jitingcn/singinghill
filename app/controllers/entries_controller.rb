class EntriesController < ApplicationController
  before_action :authenticate_user!, only: %i[update destroy]
  before_action :set_entry, only: %i[show edit update destroy]

  # GET /entries or /entries.json
  def index
    @entries = Entry.all
  end

  # GET /entries/1 or /entries/1.json
  def show
    # authorize! @entry
  end

  # GET /entries/new
  # def new
  #   @entry = Entry.new
  # end

  # GET /entries/1/edit
  def edit
    @hints = Entry.joins(:project_file)
                  .where.not(id: @entry.id)
                  .where("(source <-> '#{@entry.source}') < 0.8")
                  .from("(SELECT DISTINCT ON (chinese) * FROM entries) entries")
                  .select(:name, :source, :chinese, "(source <-> '#{@entry.source}') as distance")
                  .order("distance")
                  .limit(4)
                  .to_a.map(&:serializable_hash)
                  .uniq { |p| p["chinese"] }
                  .each { |p| p.delete("id") }
    @nouns = Noun.where("? ~ source", @entry.source).pluck(:source, :chinese)
  end

  # POST /entries or /entries.json
  # def create
  #   @entry = Entry.new(entry_params)
  #
  #   respond_to do |format|
  #     if @entry.save
  #       format.html { redirect_to @entry, notice: "Entry was successfully created." }
  #       format.json { render :show, status: :created, location: @entry }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @entry.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /entries/1 or /entries/1.json
  def update
    # authorize! @entry
    previous_chinese = @entry.chinese
    status_params = params.fetch(:entry, {}).permit(:status)
    respond_to do |format|
      if status_params && current_user.admin? && status_params["status"] != @entry.status
        @entry.update(status_params)
        audit! :update_entry, @entry, payload: { message: "条目状态更改为 #{@entry.status}" }
      end
      if previous_chinese == entry_params.fetch(:chinese)
        format.html { redirect_to @entry, notice: "" }
        format.json { render :show, status: :ok, location: @entry }
      elsif @entry.update(entry_params.merge(user_id: current_user.id))
        if previous_chinese != @entry.chinese
          audit! :update_entry, @entry, payload: entry_params.merge(previous_chinese: previous_chinese)
        end
        format.html { redirect_to @entry, notice: "Entry was successfully updated." }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
    # rescue_from ActionPolicy::Unauthorized do
    #   redirect_to new_user_session_path
    # end
  end

  # DELETE /entries/1 or /entries/1.json
  # def destroy
  #   @entry.destroy
  #   respond_to do |format|
  #     format.html { redirect_to entries_url, notice: "Entry was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_entry
    @entry = Entry.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def entry_params
    params["entry"]["chinese"] = params["entry"]["chinese"].gsub(/(?<!\r)\n/, "\r\n")
                                                           .gsub(/\.\.\./, "…")
                                                           .strip
    params.fetch(:entry, {}).permit(:chinese)
  end
end
