class IndexForeignKeysInDrafts < ActiveRecord::Migration
  def change
    add_index :drafts, :element_id
    add_index :drafts, :user_id
  end
end
