class CreateParamCategories < ActiveRecord::Migration
  def self.up
    # it is category of section_piece_params
    # 1. we want to expand&collapse
    # 2. we want to get a group of param_values, ex. general position : width, height,outer_margin, margin, border, padding.
    create_table :param_categories, :force=>true do |t|
      t.column "editor_id",              :integer, :limit => 3,     :null => false, :default => 0
      t.column "position",               :integer, :limit => 3,     :null => true,  :default => 0
      t.column "perma_name",             :string,   :limit => 200,   :null => false, :default => ""
      t.column "is_enabled",              :boolean,                   :null => false, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :param_categories
  end
end
