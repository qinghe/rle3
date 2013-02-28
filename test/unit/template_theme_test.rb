require 'test_helper'

class TemplateThemeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test 'copy to new' do
    
  end
  
  test 'should get full_param_values' do
    
  end
  
  test 'add_param_values' do
    
  end
  
  test 'should assign resource' do
    template = TemplateTheme.first

    title = 'Main menu'

    main_menu_section = template.page_layout.self_and_descendants.where(:title=>title).first
    main_menu = Menu.find_by_title(title)

    template.assign_resource(main_menu, main_menu_section)
    template.reload
    assert template.assigned_resource_ids[main_menu_section.id][:menu].include?(main_menu.id)
  end
  
end
