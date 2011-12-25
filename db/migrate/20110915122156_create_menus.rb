class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.integer :website_id, :null=> false, :default=>0
      t.string :title
      t.string :perma_name
      t.integer :root_id
      t.integer :parent_id # keep it default null,  awesome_nested_set required.
      t.integer :lft
      t.integer :rgt
      t.boolean :clickable, :default=>true
      t.boolean :is_enabled, :default=>true
      t.boolean :inheritance, :default=>true
      t.integer :theme_id, :null=> false, :default=>0
      t.integer :detail_theme_id, :null=> false, :default=>0
      t.integer :ptheme_id, :null=> false, :default=>0
      t.integer :pdetail_theme_id, :null=> false, :default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :menus
  end
end
