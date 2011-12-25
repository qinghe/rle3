# there are two kinds of event,   param_value_event and global_param_value_event, 
# param value changed, will trigger param_value_event, it tell other param value in own section, this value changed.
# a param_value_event may trigger global_param_value_event, tell other section, the param_values in is changed. for now it is only tell children.
# this event system is mainly build for modifying layout to fixed or fluid.
# to implement, in section tables, add column, section_event, it include all reserved event by this section.     

class GlobalParamValueEvent < AbstractSectionEvent
  attr_accessor :param_value, :html_attribute, :event, :original_html_attribute_value, :new_html_attribute_value
  attr_accessor :updated_html_attribute_values
  
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
    page_layout = self.param_value.page_layout
    # get all section instance which reserved the current section event.
    # pls = page_layout.root.self_and_descendants.select{|layout| layout.subscribe_event?(self.new_html_attribute_value)}
    # we load all layout tree here. so we could preload all param_value for each section instance.
    pls = page_layout.root.self_and_descendants        
      section_instances = SectionInstance.ultra_instantiate(pls)
      for si in section_instances
        si.notify(self)
      end
    self.updated_html_attribute_values

  end
  
  #event_name+'_event_handler', is handler name of this event.
  def event_name
    self.html_attribute.perma_name
  end
  # original html attribute value - new html attribute value
  def difference #delta
    #TODO, html_attribute.repeat >1
    self.event == ParamValue::EventEnum[:pv_changed] ? original_html_attribute_value['pvalue']-new_html_attribute_value['pvalue'] : 0
  end
  
  
  def source_section_name
    self.new_html_attribute_value.param_value.section.perma_name
  end
  
end

