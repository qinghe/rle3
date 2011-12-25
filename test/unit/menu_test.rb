require 'test_helper'

class MenuTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "menu_level" do
    root = Menu.root    
    child = root.children.fist
    root.inheritance = false
    
    assert child.menu_level.nil?
    
  end
  
end
