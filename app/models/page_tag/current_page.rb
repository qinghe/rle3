# current page, it is current menu item.
# current_page -> website
#              -> template -> param_values
#                          -> menus
#                          -> named_resource (blog_posts, products)
#                          -> current_resource( product, blog_post )
#                          # those tags required current section_instance
#                   
# tags in page
# template.current_section.menu == template.menus.select
# template.current_section.param_values == template.param_values.select
module PageTag
  class CurrentPage < Base

    attr_accessor :website_tag, :template_tag
    delegate :menu, :to => :page_generator
    delegate :resource, :to => :page_generator
    
    def initialize(page_generator_instance)
      super(page_generator_instance)
      self.website_tag = ::PageTag::Website.new(page_generator_instance)
      self.template_tag = ::PageTag::Template.new(page_generator_instance)
    end
    
    #title is current page title,  resource.title-menu.title-website.title
    def title
      "#{menu.title} - #{menu.website.title}"
    end
    
    #get current page's resource by template.current_piece 
    def resources()
      objs = []
      data_source = self.template_tag.current_piece.data_source
      if data_source.present?
        if data_source == 'gpvs'
          objs = menu.blog_posts
        end
      end
      objs
    end
    
    #is given section context valid to current page 
    def valid_context?
      if self.resource.present? #product detail
        self.template_tag.current_piece.context_either? or self.template_tag.current_piece.context_detail?  
      else
        self.template_tag.current_piece.context_either? or self.template_tag.current_piece.context_list?
      end

    end
  end
  
end

