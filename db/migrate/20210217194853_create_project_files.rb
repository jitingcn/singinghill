class CreateProjectFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :project_files do |t|
      t.string :name, unique: true, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
