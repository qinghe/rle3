module PageEvent
# there are two kinds of event,   param_value_event and global_param_value_event, 
# param value changed, will trigger param_value_event, it tell other param value in own section, this value changed.
# a param_value_event may trigger global_param_value_event, tell other section, the param_values in is changed. for now it is only tell children.
# this event system is mainly build for modifying layout to fixed or fluid.
# to implement, in section tables, add column, section_event, it include all reserved event by this section.     

  class GlobalParamValueEvent < ParamValueEventBase

    # it should return updated_html_attribute_values, action collect them and update the editor.  
    def notify(  )
      html_page = self.param_value.template_theme.html_page
      
      # get all section instance which reserved the current section event.
      # pls = page_layout.root.self_and_descendants.select{|layout| layout.subscribe_event?(self.new_html_attribute_value)}
      # we load all layout tree here. so we could preload all param_value for each section instance.
      
        for html_piece in html_page.partial_htmls
          self.updated_html_attribute_values.concat( self.send( handler_name, html_piece) )
        end
      self.updated_html_attribute_values
  
    end
    
    #event_name+'_event_handler', is handler name of this event. 
    def event_name
      # ex. page_layout + fixed =  page_layout_fixed
      self.param_value.section_param.section_piece_param.class_name+'_'+self.html_attribute.slug
    end
    
    def handler_name
      "#{event_name}_event_handler"
    end
    
    # original html attribute value - new html attribute value
    def difference #delta
      #TODO, html_attribute.repeat >1
      self.event == ParamValue::EventEnum[:pv_changed] ? original_html_attribute_value['pvalue'].to_i-new_html_attribute_value['pvalue'].to_i : 0
    end
    
    
    def source_section_name
      self.new_html_attribute_value.param_value.section.slug
    end
    
        
  # here are some user case
  # center_part, left_part and right_part should always have same width unit.  
  #                                                            fixed,                                     fluid                    
  # 0. change left_part width from 150px to 200px     left_part_width+50, center_part_width-50   
  # *1. change left_part width from 150px to 20%
  # *2. change left_part width from 15% to 200px
  # *3. center_area width from 100% to 800px 
  # *4. center_area width from 800px to 100%  
  # 5. page width from 800px to 900px
    
    # params: param_value_event is instance of GlobalParamValueEvent  
    def block_width_event_handler( param_value_event )
      # TODO make sure each child's width less then the container's width 
      # TODO support unit %
      is_value_changed = (param_value_event.event == ParamValue::EventEnum[:pv_changed]) # value changed or unit changed
      is_fixed = self.fixed?
      source_section_name = param_value_event.source_section_name
      part_triggered = ['center_part','left_part','right_part'].include? source_section_name
      page_triggered = ['root'].include? source_section_name
      # width of one in these three changed.       
      if self.section_slug=='center_area'
        left_part = self.children.select{|s| s.section_slug=='left_part'}.first
        right_part = self.children.select{|s| s.section_slug=='right_part'}.first
        center_part = self.children.select{|s| s.section_slug=='center_part'}.first
  Rails.logger.debug "left_part=#{left_part}, right_part=#{right_part}, center_part=#{center_part}"        
        if part_triggered
          if false #is_fixed, enable fixed center_area later. 
            center_part_width = center_part.html_attribute_values( 'block_width' )
            if source_section_name == 'left_part'
              center_part_width['pvalue']+= param_value_event.difference
  
            elsif  source_section_name == 'right_part'
              
            else
              
            end
          else          
            left_part_block_width =  left_part.html_attribute_values( 'block_width' )            
            left_part_block_margin = left_part.html_attribute_values( 'block_margin' )
            right_part_block_width = right_part.html_attribute_values( 'block_width' )
            right_part_block_margin = right_part.html_attribute_values( 'block_margin' )
            center_part_inner_margin = center_part.html_attribute_values( 'inner_margin' )
            if source_section_name == 'left_part'
              center_part_inner_margin['pvalue3']+= param_value_event.difference
              left_part_block_margin['pvalue1'] = -left_part_block_width['pvalue'] #margin-right = -left_part.width
            elsif  source_section_name == 'right_part'
              center_part_inner_margin['pvalue1']+= param_value_event.difference   
              right_part_block_margin['pvalue3'] = -right_part_block_width['pvalue'] #margin-left = -right_part.width                 
            end
            self.updated_html_attribute_values.push(center_part_inner_margin, left_part_block_margin, right_part_block_margin)
          end
          
        end                   
      end    
    end

    
  end

end