require 'test_helper'

class PageGeneratorTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test 'should build template' do
    theme_id = 1; layout_id = 0
    theme = TemplateTheme.find(theme_id)
    @lg = PageGenerator.builder( theme)
    html, css = @lg.build
    assert html.present?
    assert css.present?
  end
end
