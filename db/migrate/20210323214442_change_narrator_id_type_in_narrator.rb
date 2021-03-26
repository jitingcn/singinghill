class ChangeNarratorIdTypeInNarrator < ActiveRecord::Migration[6.1]
  def change
    change_column :narrators, :narrator_id, :string
    add_index :narrators, :narrator_id
    add_index :narrators, :narrator_source, unique: false
    add_index :narrators, :narrator_chinese, unique: false
  end
end
