blog_posts = [
 {:title=>'first blog',
 :body =>'<p>first blog content.</p><p>next line.</p>'},
 {:title=>'second blog',
 :body =>'<p>second blog content</p><p>second next line.</p>'}   
 
 ]
 
for attributes in  blog_posts
  blog_post = BlogPost.create!(attributes)  
end

#assign to index

index_menu = Menu.find('Index')
index_menu.blog_posts = BlogPost.all
index_menu.save!
