require 'test_helper'

class HtmlPageTest < ActiveSupport::TestCase
  
  test "should get param_values" do
    template = TemplateTheme.first
    html_page = template.html_page
    assert html_page.param_values.present?
  end
end