class AddPgtrgmIndexToEntries < ActiveRecord::Migration[7.0]
  def change
    remove_index :entries, :source, name: "trgm_idx"
    add_index :entries, :source, opclass: :gist_trgm_ops, using: :gist, name: "trgm_index_on_entries_source"
    add_index :entries, :english, opclass: :gist_trgm_ops, using: :gist, name: "trgm_index_on_entries_english"
    add_index :entries, :chinese, opclass: :gist_trgm_ops, using: :gist, name: "trgm_index_on_entries_chinese"
  end
end
