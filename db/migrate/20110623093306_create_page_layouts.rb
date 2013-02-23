class CreatePageLayouts < ActiveRecord::Migration
  def self.up
    #section instance composite of layout
    create_table :page_layouts, :force=>true do |t|
      t.column "website_id",                :integer, :limit => 3,     :null => true,  :default => 0    
      t.column "root_id",                :integer, :limit => 3#,     :null => true,  :default => :null     
      t.column "parent_id",              :integer, :limit => 3#,     :null => true,  :default => :null
      #default value is null, acts_as_nested_set required      
      t.column "lft",                    :integer, :limit => 2,     :null => false, :default => 0
      t.column "rgt",                    :integer, :limit => 2,     :null => false, :default => 0
      t.column "title",                  :string,  :limit => 200,   :null => false, :default => ""
      t.column "perma_name",             :string,  :limit => 200,   :null => false, :default => ""
      t.column "section_id",             :integer, :limit => 3,     :null => true,  :default => 0
      # id of sections, only root could be here.
      t.column "section_instance",       :integer, :limit => 2,     :null => false, :default => 0
      t.column "section_context",        :string,  :limit => 32,    :null => false, :default => ""
      t.column "data_source",            :string,  :limit => 32,    :null => false, :default => ""
      t.column "data_filter",            :string,  :limit => 32,    :null => false, :default => ""
      t.column "is_enabled",             :boolean,                  :null => false, :default => true
      # this node is copy from another tree, ex. center area is a layout tree, we prebuilt it for user.
      # value is layout tree's root_id.  
      t.column "copy_from_root_id",              :integer,                  :null => false, :default => 0
      # it is only for root record, this layout tree is full html page.
      # there are two kinds of layout tree  full_html_page and part_html_page
      t.column "is_full_html",             :boolean,                :null => false, :default => false
      t.timestamps
      
    end
  end

  def self.down
    drop_table :page_layouts
  end
end
