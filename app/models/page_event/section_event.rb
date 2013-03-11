module PageEvent
  class SectionEvent < AbstractEvent
    # when user modify section, like disable, remove, will trigger section event.
    # there are event, section_disabled, section_removed,
    # ex. user disable a section like 'left_part', we need tell other section like 'center part' and 'right_part', it is disabled, please update your width. 
    # now only support section_disabled, 
    attr_accessor :event_name 
    attr_accessor :page_layout, :section # which section instance trigger the section event 
  
    def initialize(event_name, page_layout)
      self.event_name = event_name
      #event_name, this is required in section_instance.notify, 
      self.page_layout = page_layout
      self.section = page_layout.section
    end
    
    
    def notify
      # get all section instance which reserved the current section event.
      pls = self.page_layout.root.nodes_for_event(self)      
      unless pls.empty?  
        section_instances = SectionInstance.ultra_instantiate(pls)
        for si in section_instances
          si.notify(self)
        end
      end
    end
    
    # there are event, section_disabled, section_removed,
    # ex. user disable a section like 'left_part', we need tell other section like 'center part' and 'right_part', it is disabled, please update your width.   
    def section_disabled_event_handler(section_event)
      source_section_name = section_event.source_section_name
           
    end
    
  end
  
end