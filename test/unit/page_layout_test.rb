require 'test_helper'

class PageLayoutTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create new layout" do
    atts={"is_enabled"=>"1", "section_id"=>"1", "slug"=>"layout1", "section_instance"=>"0", "parent_id"=>""}
    page_layout = PageLayout.new
    page_layout.attributes= atts
    assert page_layout.save
  end
  
  test "should create a root" do
    root_attrs = { "slug"=>"xyz"}
    root = PageLayout.create(root_attrs) 
    assert root.root?
  end
  
  test "should create a root by dup" do
    
    #lft, rgt is updated automatically, updated_at, created_at is same as original.
    original_count = PageLayout.count
    assert PageLayout.root.dup.save
    assert PageLayout.count == original_count.succ
  end
  
  test "should create page layout tree" do    
   # PageLayout.delete_all              
    section_roots = Section.roots
    section_hash = section_roots.inject({}){|h,sp| h[sp.slug] = sp; h}
    puts "section_hash=#{section_hash.keys}"
    root = PageLayout.create_layout(section_hash['root'].id, :slug=>"layout1")
    header = root.add_section(section_hash['container'].id)
    body = root.add_section(section_hash['container'].id)
    footer = root.add_section(section_hash['container'].id)
    body.add_section(section_hash['menu'].id)

  end
  
  
  test "should get themes" do
    
    root = PageLayout.root
    assert root.themes
    
  end
  
  test "should assign context" do
    # assign context
    root = PageLayout.full_html_roots.first
    either_context = PageLayout::ContextEither
    list_context = PageLayout::ContextEnum.list
    detail_context = PageLayout::ContextEnum.detail
    
    assert root.current_context == either_context
    
    root.update_section_context either_context
    assert root.section_context.blank?
    
    root.update_section_context list_context
    assert root.section_context == list_context.to_s
    
    for node in root.self_and_descendants
      # assert get correct inherited contexts 
    Rails.logger.debug "node.id=#{node.id},node.current_context=#{node.current_context.inspect},list_context=#{list_context.inspect}"
      assert node.current_context == list_context
    end
    
    first_child = root.children.first
    
    # do not update context if new context conflict with inherited context
    first_child.update_section_context detail_context
    assert first_child.current_context == list_context
    
    # correct descendant's context
    root.update_section_context either_context
    first_child.update_section_context detail_context    
    root.update_section_context list_context

    assert root.section_context == list_context.to_s
    assert root.children.first.section_context.blank?
    
        
  end
  
  test "should get available data source" do
    root = PageLayout.full_html_roots.first
    #get right available data source
    list_context = PageLayout::ContextEnum.list
    detail_context = PageLayout::ContextEnum.detail
    root.update_section_context list_context
    assert root.available_data_sources == PageLayout::ContextDataSourceMap[list_context]
    root.update_section_context detail_context
    assert root.available_data_sources == PageLayout::ContextDataSourceMap[detail_context]
    
  end

  test "should get data source" do
    root = PageLayout.full_html_roots.first
    data_source_nodes = root.descendants.where('data_source!=?','')
    
    for node in data_source_nodes
      assert node.current_data_source.present?
Rails.logger.debug "node.current_data_source=#{node.current_data_source.inspect}"
      assert PageLayout::DataSourceChainMap.key? node.current_data_source
      
      if node.inherited_context == PageLayout::ContextEither
        assert node.inherited_data_source==PageLayout::DataSourceEmpty
      else
        if node.has_child?
          assert node.children.first.inherited_data_source==node.current_data_source          
        end     
      end      
    end
    #get right data source
    
  end



  test "data filter" do
    #self.current_data_source==gpvs, data filter should be 'product','group'

    #self.inherited_data_source==gpvs, data filter should be 'product','group'
    
    #self.current_data_source=='|product', data filter should be 'product','group'

    #self.inherited_data_source==|group, data filter should be fixed 'group'
    
  end  
end
