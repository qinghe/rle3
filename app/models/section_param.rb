class SectionParam < ActiveRecord::Base  
  has_one :default_param_value, :conditions=>["layout_id=? and theme_id=?",0,0]
  belongs_to :section_piece_param
  serialize :defalut_value, Hash
  
  
  def disabled_html_attribute_ids
    if @disabled_html_attribute_ids.nil?
      @disabled_html_attribute_ids = self.disabled_ha_ids.split(',').collect{|i|i.to_i}
    end
    @disabled_html_attribute_ids
  end
  
  
  #filter:  :all, :disabled, :enabled
  def html_attributes(attribute_filter= :enabled)
    if @html_attributes.nil?
      ha_ids = self.section_piece_param.html_attribute_ids.split(',').collect{|i|i.to_i}
      @html_attributes= HtmlAttribute.find_by_ids(ha_ids)
    end

    case attribute_filter
    when :enabled
      return_html_attributes = @html_attributes.select{|ha| !disabled_html_attribute_ids.include?(ha.id)}
    when :disabled
      return_html_attributes = @html_attributes.select{|ha| disabled_html_attribute_ids.include?(ha.id)}      
    else
      return_html_attributes = @html_attributes
    end
    
  end
  
  
end
