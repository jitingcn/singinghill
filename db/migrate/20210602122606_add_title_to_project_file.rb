class AddTitleToProjectFile < ActiveRecord::Migration[6.1]
  def change
    add_column :project_files, :title, :string
  end
end
