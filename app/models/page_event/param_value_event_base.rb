module PageEvent
  class ParamValueEventBase < AbstractEvent 
    attr_accessor :param_value, :html_attribute, :event, :original_html_attribute_value, :new_html_attribute_value
    attr_accessor :updated_html_attribute_values
    
    def initialize(event, param_value,original_html_attribute_value, new_html_attribute_value)
      self.event = event
      self.param_value = param_value
      self.html_attribute = original_html_attribute_value.html_attribute
      self.original_html_attribute_value = original_html_attribute_value
      self.new_html_attribute_value = new_html_attribute_value    
      self.updated_html_attribute_values = []  
    end
  end
end  