require 'test_helper'

class HtmlAttributeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should find html_attribute by ids" do
    ids = [1,2]
    ha_array = HtmlAttribute.find_by_ids(ids)
    assert ha_array.size==2
    
    ha_array = HtmlAttribute.find_by_ids(1)
    
    assert ha_array.kind_of?(HtmlAttribute)
  end
  
  test "should get default values" do
    HtmlAttribute.all.each{|ha|
      if ha.has_default_value?
        assert ha.default_properties.present?
      end
    }
    
  end
  
  
  test 'width has manual selected value' do
    html_attribute_width = HtmlAttribute.find('width')
    assert html_attribute_width.manual_selected_value.present?
  end
  
end
