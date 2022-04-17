class ApplicationController < ActionController::Base
  impersonates :user
  before_action :set_paper_trail_whodunnit
  include CableReady::Broadcaster
  include Pagy::Backend

  def render_flash
    render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
  end
end
