class CreateSectionParams < ActiveRecord::Migration
  def self.up
    create_table :section_params do |t|
      t.integer :section_id
      t.integer :section_piece_id
      t.integer :section_piece_instance
      t.integer :section_piece_param_id
      t.string  :default_value   #,   :null => false, :default => ""
      t.boolean :is_enabled,     :default=>true
      t.string :disabled_ha_ids, :limit=>255, :null => false, :default => ""

      t.timestamps
    end
    
  end

  def self.down
    drop_table :section_params
  end
end
