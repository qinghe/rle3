module PageTag
  class TemplateImage 
    attr_accessor :template_tag
    attr_accessor :images_cache
     
    def initialize(template_tag)
      self.template_tag = template_tag
      self.images_cache = {}
    end
    
        # get menu root assigned to section instance
    def get( wrapped_page_layout )
      key = wrapped_page_layout.to_key 
      unless images_cache.key? key
        template_image = nil
        image_id = wrapped_page_layout.assigned_image_id
        if image_id > 0          
          template_image = TemplateFile.find(image_id)
        end
        images_cache[key] = template_image     
      end
      if images_cache[key].present?
        images_cache[key]
      else
        nil  
      end
    end
    
    def image
      get( template_tag.current_piece )
    end
    
  end
end