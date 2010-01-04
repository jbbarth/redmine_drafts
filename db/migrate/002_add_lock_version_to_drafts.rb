class AddLockVersionToDrafts < ActiveRecord::Migration
  def self.up
    add_column :drafts, :lock_version, :integer
  end

  def self.down
    remove_column :drafts, :lock_version
  end
end
