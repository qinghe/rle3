module PageEvent
  class ParamValueEvent < ParamValueEventBase
    # it should return updated_html_attribute_values, action collect them and update the editor.  
    def notify(  )
      param_conditions = self.param_value.section_param.section_piece_param.param_conditions
      
      unless param_conditions[self.html_attribute.id].nil?
        Rails.logger.debug "param_conditions=#{param_conditions.inspect},self.event=#{self.event}"
        #event handler is html_attribute.slug + event + handler      
        if param_conditions[self.html_attribute.id].include?(self.event)
          #html_attribute.slug may contain '-', we only allow a-z,A-Z,0-9,_ by [/\w+/]
          html_page = self.param_value.template_theme.html_page
          html_piece = html_page.partial_htmls.select{|hp| hp.page_layout.id==self.param_value.page_layout_id }.pop
# Rails.logger.debug "self.param_value=#{self.param_value.inspect}"        
# Rails.logger.debug "html_piece=#{html_piece.inspect}"            
          self.updated_html_attribute_values.concat( self.send( handler_name, html_piece))    
        end      
      end
      self.updated_html_attribute_values
    end
    
    def event_name
      return event
    end
  
    def handler_name
      "#{self.html_attribute.slug[/\w+/]}_#{self.event_name}_handler"
    end
  
    def height_pv_changed_handler(partial_html)
 
      height = partial_html.html_attribute_values('block_height')
    Rails.logger.debug "partial_html=#{partial_html}"    
      if height.manual_entry?
        margin, border, padding  = partial_html.html_attribute_values('inner_margin'),
          partial_html.html_attribute_values('inner_border-width'),
          partial_html.html_attribute_values('inner_padding')
        computed_inner_height = partial_html.html_attribute_values('inner_height')
        inner_height_value = height['pvalue0'].to_i
        [0,2].each{|i|#0:top, 2: bottom
          inner_height_value-= margin["pvalue#{i}"]  if margin.manual_entry?(i)  
          inner_height_value-= border["pvalue#{i}"]  if border.manual_entry?(i)  
          inner_height_value-= padding["pvalue#{i}"] if padding.manual_entry?(i)  
            } 
    Rails.logger.debug "height=#{height['pvalue0']}, inner_height_value=#{inner_height_value}"           
        computed_inner_height['psvalue'] = height['psvalue']
        computed_inner_height['pvalue'] = inner_height_value
        computed_inner_height['unit'] = height['unit']
        computed_inner_height['unset'] = HtmlAttribute::BOOL_FALSE
        self.updated_html_attribute_values.push(computed_inner_height)
      end
    end
    # TODO width_pv_changed_handler, should not bigger than its parent's width.
    
    def margin_pv_changed_handler(partial_html)
      height_pv_changed_handler( partial_html )
      
    end 
    def padding_pv_changed_handler(partial_html)
      height_pv_changed_handler( partial_html )      
    end 

    # here are two tipical layouts,    
    #   Layout Example                                 fluid --> fixed                         fixed --> fluid
    #   layout_root1 
    #         +----center_area
    #         |       +-------center_part
    #         |       |-------header_part
    #         |       |-------left_part
    #         |       +-------right_part    
    #         |----footer   
    #  
    #   layout_root2 
    #         +--page
    #         |    +----center_area
    #         |    |       +-------center_part
    #         |    |       |-------header_part
    #         |    |       |-------left_part
    #         |    |       +-------right_part    
    #         |    +----footer   
    #         +--dialog
    #         +--message_box
    
    # rules to change layout from fixed to fluid
    #  1. it only works for container section.
    #  2. it only works while there are all container section in same level(exclude float section, ex. dialog).
    #  ex. in layout1. center_area and footer are same level,  center_part, header_part, left_part and right_part are same level 
    #  container and content layout is not horizontal, width-> unset
    #  root is also a container
    # rules to change layout from fluid to fixed             
    
    def page_layout_fixed_event_handler( global_param_value_event )
      is_fixed = global_param_value_event.new_html_attribute_value.pvalue
      parent_block_width =  self.parent_section_instance.html_attribute_values("block_width") unless self.parent.nil?    
      block_width = html_attribute_values("block_width")
      block_margin =  html_attribute_values("block_margin")
      block_inner_margin = html_attribute_values("inner_margin")
  Rails.logger.debug "is_fixed = #{is_fixed}, handle section=#{self.section.slug}"    
  
      if is_fixed
        to_fixed()
      else
        to_fluid()
      end
    end
  
    # a container, content layout attribute of parent is vertical, and have a width value, we could say to_fluid means unset the width. 
    def to_fluid()
      if self.root?
        block_min_width = html_attribute_values("page_min-width")
        block_width = html_attribute_values("page_width")
        block_margin =  html_attribute_values("page_margin")
        #block, inner
        
          block_width['unset']  = HtmlAttribute::BOOL_TRUE
          block_width['hidden']  = HtmlAttribute::BOOL_TRUE
          block_min_width['unset']  = HtmlAttribute::BOOL_FALSE
          block_min_width['hidden']  = HtmlAttribute::BOOL_FALSE
        self.updated_html_attribute_values.push(block_width,block_min_width,block_margin )
      elsif self.section.slug=='container'
    
      elsif self.section.slug=='center_area'
        # parent_width is unset
    
          
      end    
    end
    
  # a container, if have no width value, content layout attribute of ancestors are vertical, to_fixed means change nothing. 
  #              if have width value and bigger than available width, we could say to_fixed means unset the width. 
    def to_fixed()
      if self.root?
        block_min_width = html_attribute_values("page_min-width")
        block_width = html_attribute_values("page_width")
        block_margin =  html_attribute_values("page_margin")
        #block, inner
          block_width['unset']  = HtmlAttribute::BOOL_FALSE
          block_width['hidden']  = HtmlAttribute::BOOL_FALSE
          block_min_width['unset']  = HtmlAttribute::BOOL_TRUE
          block_min_width['hidden']  = HtmlAttribute::BOOL_TRUE
          block_margin['unset'] = HtmlAttribute::BOOL_FALSE
          block_margin['psvalue'] = 'auto'  
        
        self.updated_html_attribute_values.push(block_width,block_min_width,block_margin )
      elsif self.section.slug=='container'
    
      elsif self.section.slug=='center_area'
        # parent_width is unset
      end
    end
  
  end
  
end