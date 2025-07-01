class AddMissingIndexes < ActiveRecord::Migration[7.2]
  def change
    add_index :drafts, [:element_id, :element_type], if_not_exists: true
  end
end
