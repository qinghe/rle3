objs=[
  {"id"=>2, "title"=>"copy theme0", "slug"=>"copy_theme0", "layout_id"=>7}]
object_class = TemplateTheme

for ha in objs
  obj = object_class.new
  obj.send(:attributes=, ha, false)
  quoted_values = obj.class.column_names.collect{|col| obj.class.connection.quote(ha[col], col) }
  sql = "INSERT INTO #{obj.class.quoted_table_name} " +
          "(#{obj.class.column_names.join(', ')}) " +
          "VALUES(#{quoted_values.join(', ')})" 
puts "sql=#{sql}"          
  obj.connection.execute(sql)
end
             
