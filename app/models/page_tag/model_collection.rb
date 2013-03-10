module PageTag
  class ModelCollection < Base
    include Enumerable
    attr_accessor :models
    
    def initialize(page_generator_instance, models)
      super(page_generator_instance)
      @models = models
    end

    def wrapped_models
      raise 'not implement'  
    end
    
        
    def each(&block)
      self.wrapped_models.each{|item|
        yield item
      }
    end
  end
end
