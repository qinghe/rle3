objs=[
  {"title"=>"layout1", "website_id"=>1, "section_id"=>1, "lft"=>1, "root_id"=>1, "id"=>1, "is_enabled"=>true, "perma_name"=>"layout1", "section_instance"=>1, "copy_from"=>0, "parent_id"=>nil, "rgt"=>18},
  {"title"=>"container1", "website_id"=>1, "section_id"=>2, "lft"=>2, "root_id"=>1, "id"=>2, "is_enabled"=>true, "perma_name"=>"header", "section_instance"=>1, "copy_from"=>0, "parent_id"=>1, "rgt"=>7},
  {"title"=>"logo1", "website_id"=>1, "section_id"=>9, "lft"=>3, "root_id"=>1, "id"=>3, "is_enabled"=>true, "perma_name"=>"logo1", "section_instance"=>1, "copy_from"=>0, "parent_id"=>2, "rgt"=>4},
  {"title"=>"hmenu1", "website_id"=>1, "section_id"=>3, "lft"=>5, "root_id"=>1, "id"=>4, "is_enabled"=>true, "perma_name"=>"hmenu1", "section_instance"=>1, "copy_from"=>0, "parent_id"=>2, "rgt"=>6},
  {"title"=>"container2", "website_id"=>1, "section_id"=>2, "lft"=>8, "root_id"=>1, "id"=>5, "is_enabled"=>true, "perma_name"=>"content", "section_instance"=>2, "copy_from"=>0, "parent_id"=>1, "rgt"=>15},
  {"title"=>"container3", "website_id"=>1, "section_id"=>2, "lft"=>16, "root_id"=>1, "id"=>6, "is_enabled"=>true, "perma_name"=>"footer", "section_instance"=>3, "copy_from"=>0, "parent_id"=>1, "rgt"=>17},
  {"title"=>"container4", "website_id"=>1, "section_id"=>2, "lft"=>9, "root_id"=>1, "id"=>7, "is_enabled"=>true, "perma_name"=>"lftnav", "section_instance"=>4, "copy_from"=>0, "parent_id"=>5, "rgt"=>12},
  {"title"=>"container5", "website_id"=>1, "section_id"=>2, "lft"=>13, "root_id"=>1, "id"=>8, "is_enabled"=>true, "perma_name"=>"main_content", "section_instance"=>5, "copy_from"=>0, "parent_id"=>5, "rgt"=>14},
  {"title"=>"vmenu1", "website_id"=>1, "section_id"=>6, "lft"=>10, "root_id"=>1, "id"=>9, "is_enabled"=>true, "perma_name"=>"vmenu", "section_instance"=>1, "copy_from"=>0, "parent_id"=>7, "rgt"=>11}]
object_class = PageLayout

for ha in objs
  obj = object_class.new()
  obj.send(:attributes=, ha, false)
  quoted_values = obj.class.column_names.collect{|col| obj.class.connection.quote(ha[col], col) }
  sql = "INSERT INTO #{obj.class.quoted_table_name} " +
          "(#{obj.class.column_names.join(', ')}) " +
          "VALUES(#{quoted_values.join(', ')})" 
  obj.connection.execute(sql)
end
             
