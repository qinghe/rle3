require 'test_helper'

class HtmlPageTest < ActiveSupport::TestCase
  
  test "should get param_values" do
    template = TemplateTheme.first
    html_page = template.html_page
    assert html_page.param_values.present?
  end
  
  
  test 'should update height' do
    template = TemplateTheme.first
    html_page = template.html_page
    partial_html = html_page.partial_htmls.select{|partial_html| partial_html.page_layout.title == 'content' }.first
    
    partial_html['content_layout_horizontal']['pvalue'] = true
    partial_html['content_layout_horizontal'].update
        
  end
end