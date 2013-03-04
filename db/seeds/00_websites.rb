objs = [{:id=>1,:title=>'fist website', :url=>'www.rubyecommerce.com'}
    ]
for ha in  objs
  obj = Website.new
  obj.assign_attributes( ha,  :without_protection => true)
  obj.save
end