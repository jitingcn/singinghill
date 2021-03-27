class AddIndexToEntries < ActiveRecord::Migration[6.1]
  def up
    add_column :entries, :index, :integer
  end
end
