class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments, :id => false do |t|
      t.integer :website_id, :null=> false, :default=>0
      t.integer :blog_post_id, :null=> false, :default=>0
      t.integer :menu_id, :null=> false, :default=>0
      t.integer :position
      t.string  :name, :null=> false, :default=>'' #named assignments
            
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
