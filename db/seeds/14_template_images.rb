base_path = File.expand_path(File.join( File.dirname(__FILE__), 'template_images'))

logo_file_path = File.join(base_path, 'logo.gif')



File.open(logo_file_path) do|f|      
  image = TemplateFile.new
  image.template_theme = TemplateTheme.find_by_title('Template One')
  image.attachment =f 
  image.save!
end
