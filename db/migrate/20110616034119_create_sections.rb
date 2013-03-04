class CreateSections < ActiveRecord::Migration
  def self.up
    # section_piece composite of section
    create_table :sections, :force=>true do |t|
      t.column "website_id",                :integer, :limit => 3
      t.column "root_id",                :integer, :limit => 3
      t.column "parent_id",              :integer, :limit => 3
      t.column "lft",                    :integer, :limit => 2,     :null => false, :default => 0
      t.column "rgt",                    :integer, :limit => 2,     :null => false, :default => 0
      t.column "slug",             :string,   :limit => 200,  :null => false, :default => ""
      t.column "section_piece_id",       :integer, :limit => 3,     :null => true,  :default => 0
      t.column "section_piece_instance", :integer, :limit => 2,     :null => true,  :default => 0
      t.column "is_enabled",              :boolean,                 :null => false, :default => true      
      t.column "global_events",         :string,   :limit => 200,   :null => false, :default => ""
      t.column "subscribed_global_events",         :string,   :limit => 200,   :null => false, :default => ""
      #comma seperated event, ex. page_layout_fixed
    end   
  end

  def self.down
    drop_table :sections
  end
end
