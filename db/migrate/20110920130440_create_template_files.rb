class CreateTemplateFiles < ActiveRecord::Migration
  def self.up
    create_table :template_files do |t|
      t.integer :page_layout_id
      t.integer :theme_id
      t.string :file_uid
      t.string :file_name
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :template_files
  end
end
