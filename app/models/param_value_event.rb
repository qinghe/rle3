class ParamValueEvent

  attr_accessor :param_value, :html_attribute, :event, :original_html_attribute_value, :new_html_attribute_value
  attr_accessor :updated_html_attribute_values #updated_param_value_and_html_attribute_ids [[pvid,haid],[pvid,haid]..]
  def initialize(event, param_value,html_attribute,original_html_attribute_value, new_html_attribute_value)
    self.event = event
    self.param_value = param_value
    self.html_attribute = html_attribute
    self.original_html_attribute_value = original_html_attribute_value
    self.new_html_attribute_value = new_html_attribute_value
    self.updated_html_attribute_values = []
  end
  
  # it should return updated_html_attribute_values, action collect them and update the editor.  
  def notify
    param_conditions = self.param_value.section_param.section_piece_param.param_conditions
    unless param_conditions[self.html_attribute.id].nil?
      Rails.logger.debug "param_conditions=#{param_conditions.inspect},self.event=#{self.event}"
      #event handler is html_attribute.perma_name + event + handler      
      if param_conditions[self.html_attribute.id].include?(self.event)
        #html_attribute.perma_name may contain '-', we only allow a-z,A-Z,0-9,_ by [/\w+/]
        pvs = ParamValue.within_section(self.param_value).all(:include=>['section_param'=>'section_piece_param'])      
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