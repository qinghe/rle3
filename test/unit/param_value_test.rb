require 'test_helper'

class ParamValueTest < ActiveSupport::TestCase
  
  setup do
    @param_value_block = TemplateTheme.first.param_values.find(:first, :conditions=>["section_piece_params.class_name=?",'block'],
      :include=>[:section_param=>:section_piece_param])
    @param_value_inner = TemplateTheme.first.param_values.find(:first, :conditions=>["section_piece_params.class_name=? and param_values.page_layout_root_id!=param_values.page_layout_id",'inner'],
      :include=>[:section_param=>:section_piece_param])
    
  end
  
  # Replace this with your real tests.
  test "should update_html_attribute_value" do
    param_value = @param_value_block
    #test class_name 'block' if html_attribute_value.unset works.
    html_attribute = HtmlAttribute.find(21) #width
    
    hav = HtmlAttributeValue.parse_from( param_value, html_attribute )
    hav['unset'] = false
    
    updated_html_attribute_values = param_value.update_html_attribute_value(html_attribute, hav.properties, ParamValue::EventEnum[:unset_changed])
    
    assert updated_html_attribute_values.present?, 'has updated html attribute values'

    hav['pvalue']=1234
    
    updated_html_attribute_values = param_value.update_html_attribute_value(html_attribute, hav.properties, ParamValue::EventEnum[:pv_changed])
    assert updated_html_attribute_values.present?, 'has updated html attribute values'
    
    assert_equal param_value.pvalue_for_haid( html_attribute.id ), 'width:1234px', 'width should be 1234px'
    
  end
  
  test 'should triggle param value conditions' do
    param_value = @param_value_block
    #test class_name 'block' if html_attribute_value.unset works.
    html_attribute = HtmlAttribute.find(15) #'height'
    hav = HtmlAttributeValue.parse_from( param_value, html_attribute )

    hav['unset'] = false
    hav['pvalue']= 120
    
    updated_html_attribute_values = param_value.update_html_attribute_value(html_attribute, hav.properties, ParamValue::EventEnum[:pv_changed])
    assert updated_html_attribute_values.present?, 'has updated html attribute values'
    assert_equal param_value.pvalue_for_haid( html_attribute.id ), 'height:120px', 'height should be 99px'    
    assert_equal param_value.partial_html['inner_height'].build_pvalue, 'height:120px'

    param_value_inner = @param_value_inner

    html_attribute = HtmlAttribute.find(32) #'margin'
    hav = HtmlAttributeValue.parse_from( param_value_inner, html_attribute )

    hav['unset'] = false
    hav['pvalue']= 5
    
    updated_html_attribute_values = param_value_inner.update_html_attribute_value(html_attribute, hav.properties, ParamValue::EventEnum[:pv_changed])
    assert updated_html_attribute_values.present?, 'has updated html attribute values'    
    assert_equal param_value_inner.pvalue_for_haid( html_attribute.id ), 'padding:5px 5px 5px 5px', 'padding should be 5px'    
    
    partial_html = param_value_inner.partial_html 
    assert_equal partial_html['block_height'].build_pvalue, 'height:120px'
    assert_equal partial_html['inner_padding'].build_pvalue, 'padding:5px 5px 5px 5px'
    assert_equal partial_html['inner_height'].build_pvalue, 'height:110px'


  end  

    
end
