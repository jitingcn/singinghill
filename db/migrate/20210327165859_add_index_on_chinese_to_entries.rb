class AddIndexOnChineseToEntries < ActiveRecord::Migration[6.1]
  def change
    add_index :entries, :chinese
  end
end
