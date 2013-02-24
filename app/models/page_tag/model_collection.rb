module PageTag
  class ModelCollection < Base
    include Enumerable
    attr_accessor :models, :wrapped_models, :current
    
    def initialize(page_generator_instance)
      super(page_generator_instance)
      @models = nil
      @wrapped_models=nil
      @current = nil
    end
    
    def each(&block)
      self.wrapped_models.each{|item|
        yield item
      }
    end
  end
end
