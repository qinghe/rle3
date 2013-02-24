module PageTag
  class Base
    attr_accessor :page_generator
    def initialize(page_generator_instance)
      self.page_generator = page_generator_instance
    end

  end
end