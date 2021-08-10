class MoveSomeFileTypeToEvent < ActiveRecord::Migration[6.1]
  def change
    ProjectFile.where("name LIKE '%.evd.txt'").update_all(type: "Event")
  end
end
