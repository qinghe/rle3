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
end
