class Api::V1::EntriesController < Api::V1::BaseController
  before_action :api_authenticate!
  before_action :search_params, only: :search

  def search
    column = search_params.fetch :column, "source"
    text = search_params.fetch :text, nil
    @entries = Entry.where("#{column}": text).limit(search_params.fetch(:limit, 10))
  end

  private

  def search_params
    params.permit(:text, :column, :fuzzy, :limit)
  end
end
