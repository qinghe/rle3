class CreateTemplateThemes < ActiveRecord::Migration
  def self.up
    create_table :template_themes, :force=>true do |t|
      t.column :website_id,              :integer, :null => true, :default => 0 # this is an id in the page_layouts table
      t.column :layout_id,               :integer, :null => false, :default => 0 # this is an id in the page_layouts table
      t.column :title,                   :string,  :limit => 64,      :null => false, :default => ""  # the name of the property      
      t.column :perma_name,              :string,  :limit => 64,      :null => false, :default => ""  # the name of the property      
    end

  end

  def self.down
    drop_table :template_themes
  end
end
