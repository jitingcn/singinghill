# frozen_string_literal: true

class SearchReflex < ApplicationReflex
  # Add Reflex methods in this file.
  #
  # All Reflex instances include CableReady::Broadcaster and expose the following properties:
  #
  #   - connection  - the ActionCable connection
  #   - channel     - the ActionCable channel
  #   - request     - an ActionDispatch::Request proxy for the socket connection
  #   - session     - the ActionDispatch::Session store for the current visitor
  #   - flash       - the ActionDispatch::Flash::FlashHash for the current request
  #   - url         - the URL of the page that triggered the reflex
  #   - params      - parameters from the element's closest form (if any)
  #   - element     - a Hash like object that represents the HTML element that triggered the reflex
  #     - signed    - use a signed Global ID to map dataset attribute to a model eg. element.signed[:foo]
  #     - unsigned  - use an unsigned Global ID to map dataset attribute to a model  eg. element.unsigned[:foo]
  #   - cable_ready - a special cable_ready that can broadcast to the current visitor (no brackets needed)
  #   - reflex_id   - a UUIDv4 that uniquely identies each Reflex
  #   - tab_id      - a UUIDv4 that uniquely identifies the browser tab
  #
  # Example:
  #
  #   before_reflex do
  #     # throw :abort # this will prevent the Reflex from continuing
  #     # learn more about callbacks at https://docs.stimulusreflex.com/rtfm/lifecycle
  #   end
  #
  #   def example(argument=true)
  #     # Your logic here...
  #     # Any declared instance variables will be made available to the Rails controller and view.
  #   end
  #
  # Learn more at: https://docs.stimulusreflex.com/rtfm/reflex-classes
  def perform(args = {})
    query = args[:query] || ""
    return if query.blank?

    page = args[:page] || 1
    @db_mode = args[:db_mode] || false

    @regex_mode = args[:regex_mode] || false
    if @regex_mode
      begin
        Regexp.new(query)
      rescue RegexpError
        @regex_mode = false
      end
    end

    if @db_mode
      op = @regex_mode ? "~" : "ILIKE"
      pagy, @results = pagy(Entry.where("(source #{op} ?) or (chinese #{op} ?)",
        *[query.to_s] * 2),
        items: 8, page: page)
    else
      results = Entry.pagy_search(query)
      pagy, @results = pagy_meilisearch(results, items: 8, page: page.to_i)
    end
    @pagy_search = pagy_metadata(pagy)
  end
end
