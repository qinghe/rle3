class CreateEditors < ActiveRecord::Migration
  def self.up
    create_table :editors, :force=>true do |t|
      t.column "slug",             :string,   :limit => 200,   :null => false, :default => ""
      t.timestamps
    end
  end

  def self.down
    drop_table :editors
  end
end
