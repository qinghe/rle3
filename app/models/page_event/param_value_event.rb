module PageEvent
  class ParamValueEvent < ParamValueEventBase
    # it should return updated_html_attribute_values, action collect them and update the editor.  
    def notify
      param_conditions = self.param_value.section_param.section_piece_param.param_conditions
      unless param_conditions[self.html_attribute.id].nil?
        Rails.logger.debug "param_conditions=#{param_conditions.inspect},self.event=#{self.event}"
        #event handler is html_attribute.slug + event + handler      
        if param_conditions[self.html_attribute.id].include?(self.event)
          #html_attribute.slug may contain '-', we only allow a-z,A-Z,0-9,_ by [/\w+/]
          pvs = ParamValue.within_section(self.param_value)  
  Rails.logger.debug "self.param_value=#{self.param_value.inspect}"        
  Rails.logger.debug "pvs=#{pvs.inspect}"            
          section_instance = SectionInstance.new(self.param_value.page_layout,  parent_section_instance=nil, pvs)      
          self.updated_html_attribute_values.concat( section_instance.notify(self) )    
        end      
      end
      self.updated_html_attribute_values
    end
    
    def event_name
      return event
    end
  end
  
end