# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  def initialize(open_text:, modal_id:)
    @open_text = open_text
    @modal_id = modal_id
  end
end
