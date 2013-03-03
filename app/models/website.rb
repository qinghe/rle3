class Website < ActiveRecord::Base
  cattr_accessor :current
  
  def previewable?
    ret = true
    if self.index_page > 0
      menu = Menu.find(self.index_page)
      if menu.previewable?
        for theme_id in menu.assigned_theme_ids(is_prevew = true)
          theme = TemplateTheme.find(theme_id)
          for menu_root in theme.assigned_menus
            if menu_root.previewable?
              next              
            else
              for child in menu_root.children
                unless child.previewable?
                  ret = false
                  break
                end
              end #for child
            end
            break unless ret
          end #for menu_root
        end #for theme_id
      else #previewable
        ret = false
      end
    else
      ret = false
    end
  end  
  
  
  # by default get layouts for publish
  def layouts(is_for_preview = false)
    
  end
  
end
