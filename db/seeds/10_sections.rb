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
root = Section.create_section(section_piece_hash['root'].id, {:perma_name=>"root",:reserved_events=>"fixed"}, 
  {'content_layout'=>{86=>HtmlAttribute::BOOL_FALSE},
   'page'=>{21=>"width:800px",'21unset'=>unset_false, 20=>"min-width:800px", '20hidden'=>bool_true},
   'page_layout'=>{'92unset'=>unset_false,92=>bool_true}})

container = Section.create_section(section_piece_hash['container'].id, {:perma_name=>"container",:website_id=>website.id},
  {'content_horizontal'=>{86=>HtmlAttribute::BOOL_TRUE},
   'block'=>{15=>"height:100px;",21=>"width:100%", 101=>"float:left;",'disabled_ha_ids'=>'111'},
   'float'=>{},
   'inner'=>{'15hidden'=>bool_true}})


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
  