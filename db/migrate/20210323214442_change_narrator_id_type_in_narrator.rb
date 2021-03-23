class ChangeNarratorIdTypeInNarrator < ActiveRecord::Migration[6.1]
  def change
    change_column :narrators, :narrator_id, :string
    add_index :narrators, :narrator_id
  end
end
