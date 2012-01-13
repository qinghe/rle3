class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer :website_id, :null=> false, :default=>0
      t.integer :blog_post_id
      t.integer :menu_id
      t.integer :position
            
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
