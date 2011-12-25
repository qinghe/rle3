class CreateParamValues < ActiveRecord::Migration
  def self.up
    create_table :param_values, :force=>true do |t|
      t.column :root_layout_id,      :integer, :limit => 2,     :null => false, :default => 0 # this is an root layout id in the page_layouts table
      # in param_value_event, we need get page_layout 
      t.column :layout_id,      :integer, :limit => 2,     :null => false, :default => 0 # this is an id in the page_layouts table
      t.column :section_id,              :integer, :limit => 2,     :null => false, :default => 0 # this is an id in the sections table
      t.column :section_instance,        :integer, :limit => 2,     :null => false, :default => 0 # the instance of the section in the layout
      t.column :section_param_id,  :integer, :limit => 2,     :null => false, :default => 0
      t.column :theme_id,                 :integer, :limit => 2,     :null => false, :default => 0
      t.column :pvalue,                  :string #,                   :null => false, :default => "" # the user chosen value of the corresponding default_page_param (can be utf8)
      t.column :unset,                   :string #,                   :null => false, :default => false if true ignore the pvalue and do not generate an output for this param
      t.column :computed_pvalue,         :string #,                   :null => false, :default => "" #hash in yml
      t.column :preview_pvalue,          :string,                   :null => false, :default => "" 
      # only used when pclass=themeimg, if not empty this is the name of the image to use during preview, when publishing set this to empty after renaming the file on disk.
      t.column :preview_unset,           :string,                   :null => false, :default => false # if true ignore the pvalue and do not generate an output for this param
      t.timestamps
    end

  end

  def self.down
    drop_table :param_values
  end
end
