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
    
    # store the text used in the section. like pclass='txt'
    create_table :section_texts do |t|
      t.string :lang
      t.string :body
      t.timestamps
    end
    
  end

  def self.down
    drop_table :section_params
    drop_table :section_texts
  end
end
