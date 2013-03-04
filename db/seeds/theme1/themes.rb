objs=[
  {"title"=>"theme for layout1", "website_id"=>1, "id"=>1, "slug"=>"theme1", "layout_id"=>1}]
object_class = TemplateTheme

for ha in objs
  obj = object_class.new()
  obj.send(:attributes=, ha, false)
  quoted_values = obj.class.column_names.collect{|col| obj.class.connection.quote(ha[col], col) }
  sql = "INSERT INTO #{obj.class.quoted_table_name} " +
          "(#{obj.class.column_names.join(', ')}) " +
          "VALUES(#{quoted_values.join(', ')})" 
  obj.connection.execute(sql)
end
             
