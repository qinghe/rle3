class CreateTemplateFiles < ActiveRecord::Migration
  def self.up
    create_table :template_files do |t|
      t.integer :theme_id
      t.datetime :created_at
    end
    add_attachment :template_files,:attachment

  end

  def self.down
    drop_table :template_files
  end
end
