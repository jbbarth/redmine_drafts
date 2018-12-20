class IndexForeignKeysInDrafts < ActiveRecord::Migration[4.2]
  def change
    add_index :drafts, :element_id
    add_index :drafts, :user_id
  end
end
