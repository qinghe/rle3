=begin
objs=[
  { "is_enabled"=>true, "section_id"=>1, "id"=>1, "root_id"=>1, "parent_id"=>0, "lft"=>1, "rgt"=>10, "section_instance"=>0, "perma_name"=>"layout1"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>2, "root_id"=>1, "parent_id"=>1, "lft"=>2, "rgt"=>9, "section_instance"=>0, "perma_name"=>"bd"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>3, "root_id"=>1, "parent_id"=>2, "lft"=>3, "rgt"=>4, "section_instance"=>2, "perma_name"=>"header"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>4, "root_id"=>1, "parent_id"=>2, "lft"=>5, "rgt"=>8, "section_instance"=>3, "perma_name"=>"content"},
  { "is_enabled"=>true, "section_id"=>3, "id"=>5, "root_id"=>1, "parent_id"=>4, "lft"=>6, "rgt"=>7, "section_instance"=>0, "perma_name"=>"menu"}]

  PageLayout.delete_all              
  for ha in objs
    obj = PageLayout.new
    obj.send(:attributes=, ha, false)
    obj.save
  end
=end                

# section perma_names= [root,container,menu]
objects = Section.roots
section_hash= objects.inject({}){|h,sp| h[sp.perma_name] = sp; h}
# puts "section_hash=#{section_hash.keys}"
website_id = section_hash['root'].website_id
  
# blog_post_list_or_detail
blog_post_list_or_detail =  PageLayout.create_layout(section_hash['container'], "blog_list_or_detail", :website_id=>website_id) 
blog_list = blog_post_list_or_detail.add_section(section_hash['container'].id,:perma_name=>"blog_list")
blog_detail = blog_post_list_or_detail.add_section(section_hash['container'].id,:perma_name=>"blog_detail")
blog_list.update_section_context( PageLayout::ContextEnum.list )
blog_list.update_data_source( PageLayout::ContextDataSourceMap[PageLayout::ContextEnum.list].first )
blog_detail.update_section_context( PageLayout::ContextEnum.detail )
blog_detail.update_data_source( PageLayout::ContextDataSourceMap[PageLayout::ContextEnum.detail].first )

# center area
center_area = PageLayout.create_layout(section_hash['center_area'], "center_area", :website_id=>website_id)
center_area.add_section(section_hash['center_part'].id,:perma_name=>"center_part")
center_area.add_section(section_hash['left_part'].id,:perma_name=>"left_part")
center_area.add_section(section_hash['right_part'].id,:perma_name=>"right_part")
  
  
  
root = PageLayout.create_layout(section_hash['root'], "layout1", :website_id=>website_id)

header = root.add_section(section_hash['container'].id,:perma_name=>"header")
header.add_section(section_hash['logo'].id)
header.add_section(section_hash['hmenu'].id)

body = root.add_section(section_hash['container'].id,:perma_name=>"content")
footer = root.add_section(section_hash['container'].id,:perma_name=>"footer")

lftnav = body.add_section(section_hash['container'].id,:perma_name=>"lftnav")
main_content = body.add_section(section_hash['container'].id,:perma_name=>"main_content")

lftnav.add_section(section_hash['vmenu'].id,:perma_name=>"vmenu")
main_content.add_layout_tree(blog_post_list_or_detail.id)

footer.add_section(section_hash['hmenu'].id,:perma_name=>"footer_menu")
footer.add_section(section_hash['text'].id,:perma_name=>"copyright")
