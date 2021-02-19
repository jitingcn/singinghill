class ChangeEntryStringToText < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change_table :entries do |t|
        change.up do
          t.change :source, :text
          t.change :english, :text
          t.change :chinese, :text
        end
        change.down do
          t.change :source, :string
          t.change :english, :string
          t.change :chinese, :string
        end
      end
    end

  end
end
