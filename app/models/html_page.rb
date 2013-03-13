# a template, actually it is html + css + data
# sometimes, we want to handle html+css. ex. edit template theme.

# since page_layout tree is full html page, each page_layout node is a section instance, 
# is piece of html, it has some param_values, some param_values relate to positioning.
# ex. width, height, padding, margin, border. for coding convenient, we want quick accessor
# to those html attribute from a page_layout, ex. page_layout.width, page_layout.height.
# this HtmlAttributeAccessor just do this.

# page_layout may has several template. so the right direction is template.one_page_layout.width


class HtmlPage# it correspond to template
  
  attr_accessor  :template
  
  def initialize( template )
    self.template = template
  end

  def param_values
      # class_name = [block, inner, page, layout]
      pvs = template.param_values.all(:conditions=>[], :include=>[{:section_param=>:section_piece_param},:section])      
  end
  
  # disassemble template into partial_html
  def partial_htmls
      @partial_htmls =[]
      #get general param values for section instances
      
      page_layouts = self.template.page_layout.self_and_descendants
      # class_name = [block, inner, page, layout]
      pvs = self.param_values  
          
      for page_layout in page_layouts
        pvs_for_layout = pvs.select{|pv| pv.page_layout_id==page_layout.id}
        parent_section_instance = @partial_htmls.select{|obj| obj.is_parent_of?(page_layout)}.first
        new_section_instance =PartialHtml.new(self, page_layout,  parent_section_instance, pvs_for_layout)   
        @partial_htmls << new_section_instance
        if parent_section_instance
          parent_section_instance.children << new_section_instance
        end
      end
      return @partial_htmls
  end
  
  class PartialHtml # it correspond to page_layout node
    GlobalParamValueEventEnum={"page_layout_fixed"=>10}
    SectionEventEnum = {:disabled_event=>1, :removed_event=>2}
     
    attr_accessor :html_page, :page_layout, :section, :param_values,  :parent, :children
    attr_accessor :updated_html_attribute_values # keep unsaved html_attribute_values
    
    
    # a page_layout record, infact it is a setion instance.
    #
    # parent_section_instance, we need param values of parents of current section instance while handling event, ex. parent's width.
    
    def initialize(html_page, page_layout,  parent_section_instance=nil, pvs=[])
      self.page_layout = page_layout
      self.section = page_layout.section
      self.parent = parent_section_instance
      self.param_values = pvs
      self.children = []
      self.updated_html_attribute_values =[]
      #Rails.logger.debug "PartialHtml.initialize.param_values=#{pvs.inspect}"
    end
    
    def is_parent_of?( other_page_layout)
       self.page_layout.id == other_page_layout.parent_id
    end
    
    def children_hash
      if @children_hash.nil?
        @children_hash = children.inject({}){|h, c| h[c.slug] = c;h;}      
      end
      @children_hash
    end
            
    # set or get html_attribute_value by key.
    # key is section_param.class_name+html_attribute.slug. ex."block_width"
    # new_attribute_values, instance of HtmlAttributeValue, 
    def html_attribute_values(key)
      if @html_attribute_value_hash.nil?
        @html_attribute_value_hash = {}
        for pv in self.param_values
          class_name = pv.section_param.section_piece_param.class_name
          pv.html_attribute_values_hash.values.each{|hav|
            unique_key = hav.computed? ?  "computed_#{class_name}_#{hav.html_attribute.slug}" : "#{class_name}_#{hav.html_attribute.slug}"
            @html_attribute_value_hash[unique_key]=hav
          }        
        end
        Rails.logger.debug "html_attribute_value_hash=#{@html_attribute_value_hash.keys.inspect}"
      end
      hav = @html_attribute_value_hash[key]
    end
  
         

      
    
    # return: 0(self is fluid) or >0(real width) 
    def width    
      # it is root and fluid 
      return 0 if self.root? and !html_attribute_values("page_layout_fixed").bool_true?
      # it is root and fixed
      return html_attribute_values("page_width")['pvalue'] if self.root? 
  
      # self width unset, parent content layout is vertical.
      if self.html_attribute_values("block_width").unset? and self.parent.content_layout_vertical?
        #TODO consider the computed margin, computed_padding caused by 'border image'
        margin, border, padding = html_attribute_values("inner_margin"), html_attribute_values("inner_border-width"), html_attribute_values("inner_padding")
        computed_width = self.parent_width      
        computed_width -= (margin['pvalue1']+margin['pvalue3']) unless margin.unset? 
        computed_width -= (border['pvalue1']+border['pvalue3']) unless border.unset? 
        computed_width -= (padding['pvalue1']+padding['pvalue3']) unless padding.unset? 
          
        return computed_width  
      end
          
      return self.html_attribute_values("block_width")['pvalue'].to_i    
    end
    
    def parent_width
      self.parent.width
    end
    
    def save
      updated_html_attribute_values.each{|hav|  hav.update  }
      # update param_value.pvalue
      updated_html_attribute_values.collect{|hav| hav.param_value}.uniq.each{|pv| pv.save}
      # save param_value.pvalue  
      updated_html_attribute_values.pop(updated_html_attribute_values.length)    
    end
  
    def fixed?
      #decide by width and parent's content_layout_horizontal
      # width=unset && parent's content_layout_horizontal = true   or  width=100% or fixed=true(only for root)  
      self.width>0
    end
  
    
    def root?
      self.page_layout.root?
    end
    
    def container?
      # has html_attribute_value: content_layout_horizontal
      ! html_attribute_values("content_layout_horizontal").nil?
    end
    
    def content_layout_vertical?
      not html_attribute_values("content_layout_horizontal").bool_true?
    end
    
    def section_slug
      self.section.slug
    end  
    alias_method :[],:html_attribute_values
  end

end
