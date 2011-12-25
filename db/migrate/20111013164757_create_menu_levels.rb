class CreateMenuLevels < ActiveRecord::Migration
  def self.up
    create_table :menu_levels, :options => 'ENGINE=InnoDB DEFAULT CHARSET=ascii', :force => true do |t|
      t.column "menu_id",                :integer, :limit => 3,    :null => false, :default => 0
      t.column "level",                  :integer, :limit => 2,    :null => false, :default => 0 #start from 0, tree's root level is 0, it is also default for whole tree.
      t.column "theme_id",              :integer, :limit => 2,     :null => false, :default => 0
      t.column "detail_theme_id",       :integer, :limit => 2,     :null => false, :default => 0
      t.integer "ptheme_id",                                :null=> false, :default=>0
      t.integer "pdetail_theme_id",                         :null=> false, :default=>0
    end
  end

  def self.down
    drop_table :menu_levels
  end
end
