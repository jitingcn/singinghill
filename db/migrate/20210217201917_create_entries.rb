class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :entries do |t|
      t.integer :status, default: 0
      t.string :location, null: false, default: ""
      t.string :source, null: false
      t.string :english, null: false, default: ""
      t.string :chinese, null: false, default: ""
      t.text :comment, null: false, default: ""
      t.references :project_file, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
    add_index :entries, :source
  end
end
