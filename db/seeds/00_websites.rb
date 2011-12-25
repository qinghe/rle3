objs = [{:id=>1,:perma_name=>'fist website', :url=>'www.rubyecommerce.com'}
    ]
for ha in  objs
  obj = Website.new
  obj.send(:attributes=, ha, false)
  obj.save
end