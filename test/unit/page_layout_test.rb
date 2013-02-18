require 'test_helper'

class PageLayoutTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create new layout" do
    atts={"is_enabled"=>"1", "section_id"=>"1", "perma_name"=>"layout1", "section_instance"=>"0", "parent_id"=>""}
    page_layout = PageLayout.new
    page_layout.attributes= atts
    assert page_layout.save
  end
  
  test "should create a root" do
    root_attrs = { "perma_name"=>"xyz"}
    root = PageLayout.create(root_attrs) 
    logger.debug "root=#{root.inspect},page_layout.root=#{root.root?}"
    assert root.root?
  end
  
  test "should create a root by dup" do
    
    #lft, rgt is updated automatically, updated_at, created_at is same as original.
    original_count = PageLayout.count
    assert PageLayout.root.dup.save
    assert PageLayout.count == original_count.succ
  end
  
  test "should get themes" do
    
    root = PageLayout.root
    assert root.themes
    
  end
end
