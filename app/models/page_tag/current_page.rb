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
    
    def initialize(page_generator_instance)
      super(page_generator_instance)
      self.website_tag = ::PageTag::Website.new(page_generator_instance)
      self.template_tag = ::PageTag::Template.new(page_generator_instance)
    end
    
  end
  
end

