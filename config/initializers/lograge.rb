Rails.application.configure do
  config.lograge.enabled = true

  # add time to lograge
  # config.lograge.custom_options = lambda do |event|
  #   { time: Time.now }
  # end

  # config.lograge.keep_original_rails_log = true
  #
  # config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/lograge_#{Rails.env}.log"
end
