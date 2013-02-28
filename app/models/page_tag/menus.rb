module PageTag
  class Menus < Base
    class WrappedMenu < WrappedModel
      self.accessable_attributes=[:id,:title,:clickable?]

      def children
        self.menu_model.children.collect{|item| WrappedMenu.new(self.menus_tag, item)}
      end
          
      # url link to the menu itme's page(each menu itme link to a page).
      def url
        self.menus_tag.page_generator.build_url(:menu_id=>menu_model.id)
      end
      
      def current?
        self.menus_tag.page_generator.menu.id == self.menu_model.id
      end
      
      # since a page could have many blog_post list, get it by current section's data source
      def blog_posts
        data_source = self.section.current_data_source
        if blog_posts_tags_cache[data_source].nil?
          self.blog_posts_tags_cache[data_source] = BlogPostsTag.new(self.menus_tag.page_generator, self)
        end
        self.blog_posts_tags_cache[data_source]
      end
      
    end
    attr_accessor :menus_cache #store all menus of template, key is page_layout_id, value is menu tree
    attr_accessor :template_tag
    
    def initialize(template_tag)
      self.template_tag = template_tag
      self.menus_cache = {}
    end

    # get menu root assigned to section instance
    def get( wrapped_page_layout )
      key = wrapped_page_layout.to_key 
      unless menus_cache.key? key
        menu_tree = nil
        if wrapped_page_layout.assigned_menu_id>0          
          menu_tree = Menu.find(:all, :conditions=>["root_id = ?", wrapped_page_layout.assigned_menu_id])
        end
        menus_cache[key] = menu_tree     
      end
      if menus_cache[key].present?
        WrappedMenu.new( self, menus_cache[wrapped_page_layout.id].first)
      else
        nil  
      end
    end
    
    def menu
      get( template_tag.current_piece )
    end
    
  
    def menus
      if self.menu_models.nil?
        self.menu_models = []
        param_values =  ParamValue.find(:all,:conditions=>["layout_root_id=? and theme_id=? and param_values.section_id=? and param_values.section_instance=? and section_piece_params.pclass=?", 
          page_generator.layout_id, page_generator.theme_id, self.section['section_id'], self.section['section_instance'], 'db'],
            :include=>[:section_param=>:section_piece_param]
          )
        for pv in param_values
          menu_root_ids = pv.html_attribute_values_hash.values.collect{|hav| hav.pvalue}
          menu_roots = Menu.find(:all, :conditions=>["id in (?)",menu_root_ids])
          
          self.menu_models = menu_roots.collect{|menu| WrappedMenu.new(self, menu)} 
          self.menu_keys = pv.html_attribute_values_hash.values.collect{|hav| hav.html_attribute['perma_name']}
        end
      end
      self.menu_models
    end
    
    def menus_hash
      menus.each_index.inject({}){|h,i|h[self.menu_keys[i]] = self.menu_models[i]}
    end
  end
end