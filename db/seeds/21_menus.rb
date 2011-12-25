objs=[
  {"title"=>"Main Menu"},
  {"title"=>"Index"},
  {"title"=>"Product Category"},
  {"title"=>"Mp3"}]
  
Menu.delete_all
website = Website.first()
main_menu = Menu.create("website_id"=>website.id, "title"=>"Main Menu")
main_menu.children.create("website_id"=>website.id,"title"=>"Index")
main_menu.children.create("website_id"=>website.id,"title"=>"Blogs")
main_menu.children.create("website_id"=>website.id,"title"=>"About me")

blog_menu = Menu.create("website_id"=>website.id,"title"=>"Blog Category")
blog_menu.children.create("website_id"=>website.id,"title"=>"Learn")
blog_menu.children.create("website_id"=>website.id,"title"=>"Family")
blog_menu.children.create("website_id"=>website.id,"title"=>"Fun")

product_menu = Menu.create("website_id"=>website.id,"title"=>"Product Category")
product_menu.children.create("website_id"=>website.id,"title"=>"articals")
product_menu.children.create("website_id"=>website.id,"title"=>"album")
                
