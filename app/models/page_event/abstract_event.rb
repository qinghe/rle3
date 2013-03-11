# we want to build a page event system, any change to a page, the system would notify section or param_value which 
# subscribed proper event.
module PageEvent
  class AbstractEvent
    
    def event_name
      raise "unimplement"
    end
    
    def source_section_name
      raise "unimplement"
    end
    
    def notify
      raise "unimplement"
    end

    def handler_name
      raise "unimplement"
    end
  end
end