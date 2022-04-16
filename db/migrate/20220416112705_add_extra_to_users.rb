class AddExtraToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :extra, :jsonb, default: {}
  end
end
