task clear_cache: :environment do
  Rails.cache.clear
  puts "rails cache clear!"
end
