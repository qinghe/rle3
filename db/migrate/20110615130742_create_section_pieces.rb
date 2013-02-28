class CreateSectionPieces < ActiveRecord::Migration
  def self.up
    # it is pieces of section
    create_table :section_pieces, :options=>'ENGINE=InnoDB DEFAULT CHARSET=ascii', :force=>true do |t|
      t.column :perma_name,          :string, :limit => 100,   :null => false, :default => ""
      t.column :html,                :string, :limit => 12000,   :null => false, :default => ""
      t.column :css,                 :string, :limit => 8000,   :null => false, :default => ""
      t.column :js,                  :string, :limit => 60,      :null => false, :default => "" # a comma separated list of js ids      
      # indicate it is html root or not?
      t.column :is_root,        :boolean,                   :null => false, :default => false
      t.column :is_container,        :boolean,                   :null => false, :default => false
      t.column :is_selectable,       :boolean,                   :null => false, :default => false
      # could assign kinds of resources to this piece
      t.column :resources,           :string, :limit => 10,      :null => false, :default => ""
      t.timestamps
    end
  end

  def self.down
    drop_table :section_pieces
  end
end
