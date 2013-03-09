# since page_layout tree is full html page, each page_layout node is a section instance, 
# is piece of html, it has some param_values, some param_values relate to positioning.
# ex. width, height, padding, margin, border. for coding convenient, we want quick accessor
# to those html attribute from a page_layout, ex. page_layout.width, page_layout.height.
# this HtmlAttributeAccessor just do this.

# page_layout may has several template. so the right direction is template.one_page_layout.width

module HtmlAttributeAccessor
  class WrappedPageLayout
    
  
    
    def width
      
    end
    
    def height
      
    end
    
    def margin
      
    end
    
    def padding
      
    end
  end
  
  def section_piece_param_values
    
  end
  
end  