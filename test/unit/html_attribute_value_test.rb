require 'test_helper'

class HtmlAttributeValueTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should update unset property" do
    param_value = TemplateTheme.first.param_values.find(:first, :conditions=>["section_piece_params.class_name=?",'block'],
      :include=>[:section_param=>:section_piece_param])
    html_attribute = HtmlAttribute.find(21) #width
    
    hav = HtmlAttributeValue.parse_from( param_value, html_attribute )
    hav['unset'] = true
    assert hav.unset?
    hav['unset'] = false
    assert !hav.unset?
    
  end
end
