module PageTag
#                 template -> param_values
#                          -> menus
#                          -> named_resource (blog_posts, products)
#                          -> current_resource( product, blog_post )
#                          # those tags required current section_instance
  class Template < ModelCollection
    class WrappedPageLayout < WrappedModel
      self.accessable_attributes=[:id]
      attr_accessor :section_id, :page_layout_id
      
      def initialize(collection_tag, page_layout_id, section_id)
        
        self.collection_tag = collection_tag
        self.model = self.page_layout_id = page_layout_id        
        self.section_id = section_id
      end
      
      def wrapped_param_values()
        
      end
      
      def wrapped_menu_root
        self.tag.menus_tag.get(self)
      end

      def assign_menu_id
        return 0
      end  
      
      #Usage: get unique for current section piece instance
      def to_key        
        if self.page_layout_id and self.section_id
          "#{page_layout_id}_#{section_id}"
        end
      end
        
    end
    
    attr_accessor :param_values_tag, :menus_tag, :blog_post_tag

    def initialize(page_generator_instance)
      super(page_generator_instance)
      self.param_values_tag = ::PageTag::ParamValues.new(page_generator_instance)
      self.menus_tag = ::PageTag::Menus.new(page_generator_instance)
      self.blog_post_tag = ::PageTag::BlogPosts.new(page_generator_instance)
    end
    
    def id
      page_generator_instance.theme.id
    end
        
    #Usage: call this in template to initialize current section and section_piece
    #        should call this before call any method.
    #Params: section, in fact, it is record of table page_layout. represent a section instance
    #        section_piece, it is record of table section, represent a section_piece instance
    def select(page_layout_id, section_id)
      
      #current selected section instance, page_layout record
      self.current = WrappedPageLayout.new(self, page_layout_id, section_id)
    end
    
    def wrapped_menu_root
      self.menus_tag.get(self.current)
    end
    
    def css(selector)
      
    end
    
  end
end
