class CreateTemplateThemes < ActiveRecord::Migration
  def self.up
    create_table :template_themes, :force=>true do |t|
      t.column :website_id,              :integer, :null => true, :default => 0 # this is an id in the page_layouts table
      t.column :page_layout_root_id,               :integer, :null => false, :default => 0 # this is an id in the page_layouts table
      t.column :title,                   :string,  :limit => 64,      :null => false, :default => ""  # the name of the property      
      t.column :slug,                    :string,  :limit => 64,      :null => false, :default => ""  # the name of the property      
      #  keep all assigned resource ids to the template, it is hash
      #  {:page_layout_id={:image_ids=[], :menu_ids=[]}}
      t.column :assigned_resource_ids,   :string,  :limit => 255,      :null => false, :default => ""        
    end

  end

  def self.down
    drop_table :template_themes
  end
end
