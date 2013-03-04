class Start < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.string :title,:limit => 24,     :null => false
      t.string :slug,:limit => 24,     :null => false
      t.string :url
      t.integer :index_page,     :null => false, :default => 0
      t.integer :list_template,     :null => false, :default => 0
      t.integer :detail_template,     :null => false, :default => 0
      t.integer :plist_template,     :null => false, :default => 0
      t.integer :pdetail_template,     :null => false, :default => 0
      t.timestamps
    end  
    add_index :websites, :slug, :unique => true
    
    # This table contains the css specification, copied from the w3 website.
    # Ok, it also includes html elment attributes, but only the ones that can't be put in css
    # Users do not use this table.
    create_table :html_attributes, :force=>true do |t|
      t.column :title,              :string,                    :null => false, :default => ""  # the name of the property
      t.column :slug,               :string,                    :null => false, :default => ""  # the name of the property
      t.column :pvalues,                 :string,                    :null => false, :default => "" # comma separate list of possible values to choose from
                                 # or 0?=see below, 1=length, 2=x y, 4=t r b l, 
      t.column :pvalues_desc,            :string,                    :null => false, :default => "" # comma separate list of possible values to choose from
      t.column :punits,                  :string,                    :null => false, :default => "" # the units applicable to the property if pvalues contains l1 or l2, can be %,in,cm,mm,em,ex,pt,pc,px (l=all except %). Notation is: [l|%|f][+in,cm,mm,em,ex,pt,pc,px]
      t.column :neg_ok,                  :boolean,                   :null => false, :default => false
      t.column :default_value,           :integer,  :limit => 2,     :null => false, :default => 0
      # index in pvalues of the default pvalue (it seems always 0, i.e. the first pvalue).
      # If pvalues is manual entry only then the default manual entry. 0 = we define the default value
      t.column :pvspecial,               :string,   :limit => 7,     :null => false, :default => "" # xy, trbl or inherit
    end
    add_index :html_attributes, :slug, :unique => true

    
  end
  
  def self.down
    drop_table :websites
    drop_table :html_attributes

  end
end
