#we do not allow to call all methods of model in template, so wrap it.
module PageTag
  class WrappedModel
    class_attribute :accessable_attributes
    self.accessable_attributes = [:id]
    attr_accessor :collection_tag, :model
    def initialize(collection_tag, model)
      self.model = model
      self.collection_tag = collection_tag
    end
    
    def path
      self.collection_tag.page_generator.build_path( self.model)
    end
    
    def [](attribute_name)
      if accessable_attributes.include? attribute_name.to_sym
        #support method name
        model.send attribute_name
      else
        nil
      end
    end
  end
end