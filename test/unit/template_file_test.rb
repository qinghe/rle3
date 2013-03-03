require 'test_helper'

class TemplateFileTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should save a image" do
    base_path = File.join( Rails.root, 'public', 'images')

    logo_file_path = File.join(base_path, 'rails.png')
    File.open(logo_file_path) do|f|    
      image = TemplateFile.new
      image.attachment =f 
      image.save!
    end
    assert true
  end
end
