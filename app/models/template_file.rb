# file uploaded for template
class TemplateFile < ActiveRecord::Base
  belongs_to :template_theme, :foreign_key=>"theme_id"

  #validates_uniqueness_of :file_name
  has_attached_file :attachment
  self.attachment_definitions[:attachment][:url] = "/shops/:rails_env/1/:class/:id/:basename_:style.:extension"
  self.attachment_definitions[:attachment][:path] = ":rails_root/public/shops/:rails_env/1/:class/:id/:basename_:style.:extension"
  self.attachment_definitions[:attachment][ :default_url] = "/images/:style/missing.png"

  delegate :url, :to => :attachment

end
