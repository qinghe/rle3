module PageTag
  # blog_posts is hash, cache all named blog_posts of current page.
  # key is data_source name, value is proper blog_posts_tag
  #      self.blog_posts_tags_cache = {}
  class BlogPosts < ModelCollection
    
    class WrappedBlogPost < WrappedModel
      self.accessable_attributes=[:id,:title,:body,:published_at]
      
      def url
        self.blog_posts_tag.page_generator.build_url(
          :blog_post_id=>self.id, 
          :menu_id=>blog_posts_tag.wrapped_menu.id)
      end
      
    end  
    

    
    def blog_post_models
      if @blog_post_models.nil?
        self.blog_post_models = self.page_generator.menu.blog_posts
      end
      @blog_post_models
    end
    
    def blog_posts
      if @blog_posts.nil?
        self.blog_posts = self.blog_post_models.collect{|item| WrappedBlogPost.new(self, item)}      
      end
      @blog_posts    
    end
     

    # means the current select blog post in erubis context.
    def current
      if @current.nil? and !self.page_generator.resource.nil?
        @current = WrappedBlogPost.new( self, page_generator.resource)
      end
      @current
    end
     
  end
end