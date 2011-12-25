class TemplateFile < ActiveRecord::Base
  #validates_uniqueness_of :file_name
  image_accessor :file
end
