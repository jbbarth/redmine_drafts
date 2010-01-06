class RenameDraftsLockVersion < ActiveRecord::Migration
  def self.up
    rename_column :drafts, :lock_version, :element_lock_version
  end

  def self.down
    rename_column :drafts, :element_lock_version, :lock_version
  end
end
