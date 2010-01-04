class CreateDrafts < ActiveRecord::Migration
  def self.up
    create_table :drafts do |t|
      t.column :element_type, :string
      t.column :element_id, :integer
      t.column :user_id, :integer
      t.column :content, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :drafts
  end
end
