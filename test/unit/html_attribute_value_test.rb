require 'test_helper'

class HtmlAttributeValueTest < ActiveSupport::TestCase
  
  setup do
    @param_value_block = TemplateTheme.first.param_values.find(:first, :conditions=>["section_piece_params.class_name=?",'block'],
      :include=>[:section_param=>:section_piece_param])
  end
  
  # Replace this with your real tests.
  test "should update width property" do
    param_value = @param_value_block
    html_attribute = HtmlAttribute.find(21) #width
    
    hav = HtmlAttributeValue.parse_from( param_value, html_attribute )
    hav['unset'] = true
    assert hav.unset?
    hav['unset'] = false
    assert !hav.unset?
    
    hav['pvalue'] = 600
    hav.update
    
    assert_equal param_value.pvalue_for_haid(html_attribute.id), 'width:600px'    
  end

  test "should update layout_content property" do
    param_value = TemplateTheme.first.param_values.find(:first, :conditions=>["section_piece_params.class_name=?",'content_layout'],
      :include=>[:section_param=>:section_piece_param])
    html_attribute = HtmlAttribute.find(86) #width
    
    hav = HtmlAttributeValue.parse_from( param_value, html_attribute )
    hav['pvalue'] = true
    hav.update
    assert_equal param_value.pvalue_for_haid(html_attribute.id), '1'    
    
  end
  
  
end
