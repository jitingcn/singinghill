class AddIndexOnNameToProjectFiles < ActiveRecord::Migration[6.1]
  def change
    add_index :project_files, :name
  end
end
