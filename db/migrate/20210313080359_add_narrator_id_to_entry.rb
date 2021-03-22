class AddNarratorIdToEntry < ActiveRecord::Migration[6.1]
  def change
    add_column :entries, :narrator_id, :string, null: false, default: "", after: :location
  end
end
