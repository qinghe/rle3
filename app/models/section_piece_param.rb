class SectionPieceParam < ActiveRecord::Base
  acts_as_list :scope => :section_piece_id
  
  belongs_to :section_piece
  belongs_to :param_category
  belongs_to :editor

  serialize :param_conditions, Hash #{html_attribute_id=>[:change]}  
  
  PCLASS_DB="db" # param which contain html_attribute db should named as 'db'
  PCLASS_CSS="css" 
  PCLASS_STYLE="style" 
  
  def html_attributes
    if @html_attributes.nil?
      ha_ids = self.html_attribute_ids.split(',').collect{|i|i.to_i}
      @html_attributes= HtmlAttribute.find_by_ids(ha_ids)

    end
    @html_attributes
  end
end
