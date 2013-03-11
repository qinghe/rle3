require 'test_helper'

class ParamValueTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should update_html_attribute_value" do
    #test class_name 'block' if html_attribute_value.unset works.
    param_value = TemplateTheme.first.param_values.find(:first, :conditions=>["section_piece_params.class_name=?",'page'],
      :include=>[:section_param=>:section_piece_param])
    html_attribute = HtmlAttribute.find(21) #width
    
    hav = HtmlAttributeValue.parse_from( param_value, html_attribute )
    
    hav['pvalue']=1234
    
    updated_html_attribute_values = param_value.update_html_attribute_value(html_attribute, hav.properties, ParamValue::EventEnum[:pv_changed])
    
    assert updated_html_attribute_values.present?
    
    assert param_value.pvalue_for_haid( html_attribute.id ) == 'width:1234px'
    
  end
end
