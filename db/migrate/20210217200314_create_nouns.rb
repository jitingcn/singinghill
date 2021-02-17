class CreateNouns < ActiveRecord::Migration[6.1]
  def change
    create_table :nouns do |t|
      t.string :source, unique: true, null: false
      t.string :english, null: false, default: ""
      t.string :chinese, null: false, default: ""
      t.text :comment, null: false, default: ""
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :nouns, :source
  end
end
