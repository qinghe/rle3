module PageTag
  class WebsiteTag < Base
    
    def website
      page_generator.theme.website
    end
    
    def get(function_name)
      self.website.send function_name
    end
    
    def public_path(target)
      File.join(page_generator.layout_public_path,page_generator.theme.file_name(target))
    end
    
  end
end
