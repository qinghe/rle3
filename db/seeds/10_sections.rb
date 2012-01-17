=begin
objs=[
  {"id"=>1, "section_piece_instance"=>0, "is_enabled"=>true, "perma_name"=>"root", "section_piece_id"=>1},
  {"id"=>2, "section_piece_instance"=>0, "is_enabled"=>true, "perma_name"=>"container", "section_piece_id"=>2},
  {"id"=>3, "section_piece_instance"=>0, "is_enabled"=>true, "perma_name"=>"menu", "section_piece_id"=>3},
  {"id"=>4, "section_piece_instance"=>0, "is_enabled"=>true, "root_id"=>3, "perma_name"=>"menuitem", "parent_id"=>3, "section_piece_id"=>4}
]

Section.delete_all              
for ha in objs
  obj = Section.new
  obj.send(:attributes=, ha, false)
  obj.save
end
=end
#section_piece perma_names= [root,container,menu,menuitem]
unset_false = HtmlAttribute::UNSET_FALSE
unset_true = HtmlAttribute::UNSET_TRUE
bool_true =  HtmlAttribute::UNSET_TRUE
website = Website.first
sps = SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.perma_name] = sp; h}

Section.delete_all              
root = Section.create_section(section_piece_hash['root'].id, {:perma_name=>"root",:global_events=>"page_layout_fixed",:subscribed_global_events=>"page_layout_fixed"}, 
  {'content_layout'=>{86=>HtmlAttribute::BOOL_FALSE},
   'page'=>{21=>"width:800px",'21unset'=>unset_false, 20=>"min-width:800px", '20hidden'=>bool_true},
   'page_layout'=>{'92unset'=>unset_false,92=>bool_true}})

container = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"container",:subscribed_global_events=>"page_layout_fixed"},{'content_layout'=>{86=>bool_true,'86unset'=>unset_false},
'block'=>{15=>"height:100px",'15unset'=>unset_false,101=>"float:left",'101unset'=>unset_false}, 'inner'=>{'15hidden'=>bool_true}})


hmenu = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"hmenu",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
hmenu.add_section_piece(section_piece_hash['hmenu'].id).add_section_piece(section_piece_hash['menuitem'].id)

vmenu = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"vmenu",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})

vmenu.add_section_piece(section_piece_hash['vmenu'].id).add_section_piece(section_piece_hash['menuitem'].id)

logo = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"logo",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
logo.add_section_piece(section_piece_hash['image'].id)


text = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"text",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
text.add_section_piece(section_piece_hash['text'].id)

blog_post_list = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"blog_post_list",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
blog_post_list.add_section_piece(section_piece_hash['blog_post_list'].id).add_section_piece(section_piece_hash['blog_post'].id)

blog_post_detail = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"blog_post_detail",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
blog_post_detail.add_section_piece(section_piece_hash['blog_post_detail'].id)

################################################ center area start ##############################################  
center_area = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"center_area",:subscribed_global_events=>"page_layout_fixed,block_width"},{'content_layout'=>{86=>bool_true,'86unset'=>unset_false},
'block'=>{15=>"height:100px",'15unset'=>unset_false,:disabled_ha_ids=>"101"}})

left_part = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"left_part",:global_events=>"block_width"},
  {'content_layout'=>{86=>HtmlAttribute::BOOL_TRUE},
   'block'=>{15=>"height:100px",'15unset'=>unset_false,21=>"width:200px",'21unset'=>unset_false, 101=>"float:left",'101unset'=>unset_false,111=>"margin:0 -200px 0 0",'111unset'=>unset_false,:disabled_ha_ids=>"111"},
   'inner'=>{'15hidden'=>bool_true}})
right_part = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"right_part",:global_events=>"block_width"},
  {'content_layout'=>{86=>HtmlAttribute::BOOL_TRUE},
   'block'=>{15=>"height:100px",'15unset'=>unset_false,21=>"width:200px",'21unset'=>unset_false, 101=>"float:right",'101unset'=>unset_false,111=>"margin:0 0 0 -200px",'111unset'=>unset_false,:disabled_ha_ids=>"111"},
   'inner'=>{'15hidden'=>bool_true}})
   
center_part = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"center_part",:global_events=>"block_width"},
  {'content_layout'=>{86=>HtmlAttribute::BOOL_TRUE},
'block'=>{15=>"height:100px",'15unset'=>unset_false,21=>"width:100%",'21unset'=>unset_false, 101=>"float:left",'101unset'=>unset_false,111=>"margin:0 -100% 0 0",'111unset'=>unset_false, '111hidden'=>bool_true,:disabled_ha_ids=>"101,21"},
'inner'=>{31=>"margin:0 200px 0 200px",'31unset'=>unset_false, '31hidden'=>bool_true, '15hidden'=>bool_true}})
################################################ center area end ##############################################  

  