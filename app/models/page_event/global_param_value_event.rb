module PageEvent
# there are two kinds of event,   param_value_event and global_param_value_event, 
# param value changed, will trigger param_value_event, it tell other param value in own section, this value changed.
# a param_value_event may trigger global_param_value_event, tell other section, the param_values in is changed. for now it is only tell children.
# this event system is mainly build for modifying layout to fixed or fluid.
# to implement, in section tables, add column, section_event, it include all reserved event by this section.     

  class GlobalParamValueEvent < ParamValueEventBase

    # it should return updated_html_attribute_values, action collect them and update the editor.  
    def notify
      page_layout = self.param_value.page_layout
      # get all section instance which reserved the current section event.
      # pls = page_layout.root.self_and_descendants.select{|layout| layout.subscribe_event?(self.new_html_attribute_value)}
      # we load all layout tree here. so we could preload all param_value for each section instance.
      pls = page_layout.root.self_and_descendants.all(:include=>:section)        
        section_instances = SectionInstance.ultra_instantiate(pls)
        for si in section_instances
          self.updated_html_attribute_values.concat( si.notify(self) )
        end
      self.updated_html_attribute_values
  
    end
    
    #event_name+'_event_handler', is handler name of this event. 
    def event_name
      # ex. page_layout + fixed =  page_layout_fixed
      self.param_value.section_param.section_piece_param.class_name+'_'+self.html_attribute.slug
    end
    # original html attribute value - new html attribute value
    def difference #delta
      #TODO, html_attribute.repeat >1
      self.event == ParamValue::EventEnum[:pv_changed] ? original_html_attribute_value['pvalue'].to_i-new_html_attribute_value['pvalue'].to_i : 0
    end
    
    
    def source_section_name
      self.new_html_attribute_value.param_value.section.slug
    end
    
  end

end