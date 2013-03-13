=begin
objs=[
  {"id"=>1, "section_piece_instance"=>0, "is_enabled"=>true, "slug"=>"root", "section_piece_id"=>1},
  {"id"=>2, "section_piece_instance"=>0, "is_enabled"=>true, "slug"=>"container", "section_piece_id"=>2},
  {"id"=>3, "section_piece_instance"=>0, "is_enabled"=>true, "slug"=>"menu", "section_piece_id"=>3},
  {"id"=>4, "section_piece_instance"=>0, "is_enabled"=>true, "root_id"=>3, "slug"=>"menuitem", "parent_id"=>3, "section_piece_id"=>4}
]

Section.delete_all              
for ha in objs
  obj = Section.new
  obj.send(:attributes=, ha, false)
  obj.save
end
=end
#section_piece slugs= [root,container,menu,menuitem]
bool_false = HtmlAttribute::BOOL_FALSE
bool_true =  HtmlAttribute::BOOL_TRUE
website = Website.first
sps = SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

Section.delete_all              
root = Section.create_section(section_piece_hash['root'].id, {:title=>"root",:global_events=>"page_layout_fixed",:subscribed_global_events=>"page_layout_fixed"}, 
  {'content_layout'=>{86=>bool_false},
   'page'=>{21=>"width:800px",'21unset'=>bool_false, 20=>"min-width:800px", '20hidden'=>bool_true},
   'page_layout'=>{'92unset'=>bool_false,92=>bool_true}})

container = Section.create_section(section_piece_hash['container'].id, {:title=>"container",:subscribed_global_events=>"page_layout_fixed"},{'content_layout'=>{86=>bool_true,'86unset'=>bool_false},
'block'=>{15=>"height:100px",'15unset'=>bool_false,101=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true,'15hidden'=>bool_true}})


hmenu = Section.create_section(section_piece_hash['container'].id, {:title=>"hmenu",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
hmenu.add_section_piece(section_piece_hash['hmenu'].id).add_section_piece(section_piece_hash['menuitem'].id)

vmenu = Section.create_section(section_piece_hash['container'].id, {:title=>"vmenu",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})

vmenu.add_section_piece(section_piece_hash['vmenu'].id).add_section_piece(section_piece_hash['menuitem'].id)

logo = Section.create_section(section_piece_hash['container'].id, {:title=>"logo",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
logo.add_section_piece(section_piece_hash['image'].id)


text = Section.create_section(section_piece_hash['container'].id, {:title=>"text",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
text.add_section_piece(section_piece_hash['text'].id)

blog_post_title = Section.create_section(section_piece_hash['container'].id, {:title=>"blog post title",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
blog_post_title.add_section_piece(section_piece_hash['blog-post-title'].id)

blog_post_body = Section.create_section(section_piece_hash['container'].id, {:title=>"blog post body",:website_id=>website.id},
  {'block'=>{'disabled_ha_ids'=>'111'},
   'content_horizontal'=>{'disabled_ha_ids'=>'101'},
   'inner'=>{'15hidden'=>bool_true}})
blog_post_body.add_section_piece(section_piece_hash['blog-post-body'].id)

################################################ center area start ##############################################  
center_area = Section.create_section(section_piece_hash['container'].id, {:title=>"center_area",:subscribed_global_events=>"page_layout_fixed,block_width"},{'content_layout'=>{86=>bool_true,'86unset'=>bool_false},
'block'=>{15=>"height:100px",'15unset'=>bool_false,:disabled_ha_ids=>"101"}})

left_part = Section.create_section(section_piece_hash['container'].id, {:title=>"left_part",:global_events=>"block_width"},
  {'content_layout'=>{86=>bool_true},
   'block'=>{15=>"height:100px",'15unset'=>bool_false,21=>"width:200px",'21unset'=>bool_false, 101=>"float:left",'101unset'=>bool_false,111=>"margin:0 -200px 0 0",'111unset'=>bool_false,:disabled_ha_ids=>"111"},
   'inner'=>{'15hidden'=>bool_true}})
right_part = Section.create_section(section_piece_hash['container'].id, {:title=>"right_part",:global_events=>"block_width"},
  {'content_layout'=>{86=>bool_true},
   'block'=>{15=>"height:100px",'15unset'=>bool_false,21=>"width:200px",'21unset'=>bool_false, 101=>"float:right",'101unset'=>bool_false,111=>"margin:0 0 0 -200px",'111unset'=>bool_false,:disabled_ha_ids=>"111"},
   'inner'=>{'15hidden'=>bool_true}})
   
center_part = Section.create_section(section_piece_hash['container'].id, {:title=>"center_part",:global_events=>"block_width"},
  {'content_layout'=>{86=>bool_true},
'block'=>{15=>"height:100px",'15unset'=>bool_false,21=>"width:100%",'21unset'=>bool_false, 101=>"float:left",'101unset'=>bool_false,111=>"margin:0 -100% 0 0",'111unset'=>bool_false, '111hidden'=>bool_true,:disabled_ha_ids=>"101,21"},
'inner'=>{31=>"margin:0 200px 0 200px",'31unset'=>bool_false, '31hidden'=>bool_true, '15hidden'=>bool_true}})
################################################ center area end ##############################################  

  