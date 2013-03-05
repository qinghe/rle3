module PageTag
#                 template -> param_values
#                          -> menus
#                          -> named_resource (blog_posts, products)
#                          -> current_resource( product, blog_post )
#                          # those tags required current section_instance
# template is collection of page_layout. each page_layout is section instance 
  class Template < ModelCollection
    class WrappedPageLayout < WrappedModel
      self.accessable_attributes=[:id]
      attr_accessor :section_id, :page_layout
      delegate :section_context, :data_source,:data_filter, :to => :page_layout
      
      def initialize(collection_tag, page_layout, section_id)
        
        self.collection_tag = collection_tag
        self.page_layout = page_layout      
        self.section_id = section_id
        #self.model = 
      end
            
      #Usage: css selector for current section piece instance
      #       we may need css selector for current section instance
      def piece_selector
        if self.page_layout.id and self.section_id
          "s_#{self.to_key}"
        end
      end
      
      def to_key
        "#{page_layout.id}_#{section_id}"
      end
       
      def assigned_menu_id
        self.collection_tag.theme.assigned_resource_id(Menu, page_layout.id)
      end
      def assigned_image_id
        self.collection_tag.theme.assigned_resource_id(TemplateFile, page_layout.id)
      end
    end
    
    attr_accessor :page_layout_tree
    attr_accessor :param_values_tag, :menus_tag, :image_tag, :blog_post_tag
    delegate :css, :to => :param_values_tag 
    delegate :menu, :to => :menus_tag
    delegate :image, :to => :image_tag
    delegate :theme, :to => :page_generator
    alias_method :current_piece, :current #current piece is more readable?

    def initialize(page_generator_instance)
      super(page_generator_instance)
      self.param_values_tag = ::PageTag::ParamValues.new(self)
      self.menus_tag = ::PageTag::Menus.new(self)
      self.image_tag = ::PageTag::TemplateImage.new(self)
      self.page_layout_tree = theme.page_layout.self_and_descendants()
    end
    
    def id
      page_generator.theme.id
    end
        
    #Usage: call this in template to initialize current section and section_piece
    #        should call this before call any method.
    #Params: section, in fact, it is record of table page_layout. represent a section instance
    #        section_piece, it is record of table section, represent a section_piece instance
    def select(page_layout_id, section_id)
      
      #current selected section instance, page_layout record
      page_layout = page_layout_tree.select{|node| node.id == page_layout_id}.fist
      self.current = WrappedPageLayout.new(self, page_layout, section_id)
    end
    
  end
end
