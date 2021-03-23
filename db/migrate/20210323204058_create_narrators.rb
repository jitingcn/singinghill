class CreateNarrators < ActiveRecord::Migration[6.1]
  def change
    create_table :narrators do |t|
      t.integer :narrator_id, null: false
      t.string :narrator_source, null: false, default: ""
      t.string :narrator_chinese, null: false, default: ""
      t.timestamps
    end
  end
end
