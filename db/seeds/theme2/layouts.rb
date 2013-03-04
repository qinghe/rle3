objs=[
  {"website_id"=>1, "section_id"=>1, "lft"=>1, "root_id"=>7, "id"=>7, "is_enabled"=>true, "slug"=>"copy_layout1", "section_instance"=>1, "copy_from"=>1, "parent_id"=>nil, "rgt"=>12},
  {"website_id"=>1, "section_id"=>2, "lft"=>2, "root_id"=>7, "id"=>8, "is_enabled"=>true, "slug"=>"header", "section_instance"=>1, "copy_from"=>1, "parent_id"=>7, "rgt"=>5},
  {"website_id"=>1, "section_id"=>6, "lft"=>3, "root_id"=>7, "id"=>9, "is_enabled"=>true, "slug"=>"logo1", "section_instance"=>1, "copy_from"=>1, "parent_id"=>8, "rgt"=>4},
  {"website_id"=>1, "section_id"=>2, "lft"=>6, "root_id"=>7, "id"=>10, "is_enabled"=>true, "slug"=>"content", "section_instance"=>2, "copy_from"=>1, "parent_id"=>7, "rgt"=>9},
  {"website_id"=>1, "section_id"=>3, "lft"=>7, "root_id"=>7, "id"=>11, "is_enabled"=>true, "slug"=>"menu1", "section_instance"=>1, "copy_from"=>1, "parent_id"=>10, "rgt"=>8},
  {"website_id"=>1, "section_id"=>2, "lft"=>10, "root_id"=>7, "id"=>12, "is_enabled"=>true, "slug"=>"footer", "section_instance"=>3, "copy_from"=>1, "parent_id"=>7, "rgt"=>11}]
object_class = PageLayout

for ha in objs
  obj = object_class.new
  quoted_values = obj.class.column_names.collect{|col| obj.class.connection.quote(ha[col], col) }
  sql = "INSERT INTO #{obj.class.quoted_table_name} " +
          "(#{obj.class.column_names.join(', ')}) " +
          "VALUES(#{quoted_values.join(', ')})" 
puts "sql=#{sql}"          
  obj.connection.execute(sql)
end
             
