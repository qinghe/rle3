# Editor 
editors = [{:id=>1,:perma_name=>'config'},
  {:id=>2,:perma_name=>'position'},  
  {:id=>3,:perma_name=>'color'}, 
  {:id=>4,:perma_name=>'text'}  
    ]
for ha in     editors
  obj = Editor.new
  obj.send(:attributes=, ha, false)
  obj.save
end