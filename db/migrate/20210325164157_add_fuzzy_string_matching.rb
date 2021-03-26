class AddFuzzyStringMatching < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE extension IF NOT EXISTS pg_trgm;
      CREATE extension IF NOT EXISTS fuzzystrmatch;
    SQL
  end
end
