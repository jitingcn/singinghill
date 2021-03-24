class EntriesController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_entry, only: %i[ show edit update destroy ]

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
    respond_to do |format|
      if @entry.update(entry_params)
        if previous_chinese != @entry.chinese
          audit! :update_entry, @entry, payload: entry_params.permit(:chinese).merge(previous_chinese: previous_chinese)
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
    params.fetch(:entry, {}).merge(user_id: current_user&.id).permit(:chinese, :user_id)
  end
end
