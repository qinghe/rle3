# Editor 
editors = [
  {:id=>2,:slug=>'position'},  
  {:id=>3,:slug=>'color'}, 
  {:id=>4,:slug=>'text'}  
    ]
for ha in     editors
  obj = Editor.new
  obj.assign_attributes( ha,  :without_protection => true)
  obj.save
end