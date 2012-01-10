class TagBase
  attr_accessor :layout_generator
  def initialize(layout_generator_instance)
    self.layout_generator = layout_generator_instance
  end
  #attributes setting in template
  attr_accessor :section # hash, attributes  of model page_layout
  attr_accessor :section_piece # hash attributes of model section
      
  #Usage�� call this in template to initialize current section and section_piece
  #        should call this before call any method.
  #Params: section, in fact, it is record of table page_layout. represent a section instance
  #        section_piece, it is record of table section, represent a section_piece instance
  def setup(section_instance, section_piece_instance)
    self.section, self.section_piece = section_instance, section_piece_instance

  end
end

class MenusTag <TagBase
  
  class WrappedMenu
    attr_accessor :menus_tag, :menu_model
    
    def initialize(tag, menu)
      self.menu_model = menu
      self.menus_tag = tag
    end
    
    def children
      self.menu_model.children.collect{|item| WrappedMenu.new(self.menus_tag, item)}
    end
    
    def title
      self.menu_model.title
    end
    
    # url link to the menu itme's page(each menu itme link to a page).
    def url
      self.menus_tag.layout_generator.url_prefix+"/#{self.menu_model.id}"
    end
    
    def clickable?
      self.menu_model.clickable?
    end
  end
  
  attr_accessor :menu_models, :menu_keys # keys are section_piece_param.class_name
  def setup(section_instance, section_piece_instance)
    super(section_instance, section_piece_instance)
    self.menu_models = nil
    menus
  end
  
  def menu
    menus.first
  end
  
  def menu?
    not menus.first.nil?
  end

  # means the current select menu in erubis context.
  # we should set before generate the page.
  def current
    layout_generator.menu
  end
   
  def menus
    if self.menu_models.nil?
      self.menu_models = []
      param_values =  ParamValue.find(:all,:conditions=>["root_layout_id=? and theme_id=? and param_values.section_id=? and param_values.section_instance=? and section_piece_params.pclass=?", 
        layout_generator.layout_id, layout_generator.theme_id, self.section['section_id'], self.section['section_instance'], 'db'],
          :include=>[:section_param=>:section_piece_param]
        )
      for pv in param_values
        menu_ids = pv.html_attribute_values_hash.values.collect{|hav| hav.pvalue}
        menus = Menu.find(:all, :conditions=>["id in (?)",menu_ids])
        
        self.menu_models = menus.collect{|menu| WrappedMenu.new(self, menu)} 
        self.menu_keys = pv.html_attribute_values_hash.values.collect{|hav| hav.html_attribute['perma_name']}
      end
    end
    self.menu_models
  end
  
  def menus_hash
    menus.each_index.inject({}){|h,i|h[self.menu_keys[i]] = self.menu_models[i]}
  end
end

class ParamValuesTag < TagBase


  def param_values_hash
    if @param_values_hash.nil?
      param_values =  ParamValue.find(:all,:conditions=>["root_layout_id=? and theme_id=?", layout_generator.layout_id, layout_generator.theme_id],
        :include=>[:section_param=>:section_piece_param]
      )
      
      @param_values_hash = param_values.inject({}){|h,pv|
        sp = pv.section_param
        key = "#{pv.section_id}_#{pv.section_instance}_#{sp.section_piece_id}_#{sp.section_piece_instance}"
        h[key]||=[]   
        h[key]<<pv
        h
      }      
    end
    @param_values_hash
  end

  #usage
  # options: :source=>[computed|normal], get pvalue from 'pvalue' or 'computed_pvalue'  
  def get(class_name, options={})
    class_name = class_name.to_s
    val = ""
    if self.param_values_hash.has_key? instance_id
      pvs = param_values_hash[instance_id]
      for pv in pvs
#Rails.logger.debug "pv=#{pv.id}, pv.html_attribute_ids=#{pv.html_attribute_ids}"
        # section_piece_param which have same class_name should be given same plass
        spp = pv.section_param.section_piece_param
        if spp.class_name == class_name
          if options[:source]=='computed' #computed param value must be css 
            val<< pv.computed_pvalue.values.join(';')                           
          else
            html_attributes = HtmlAttribute.find_by_ids(pv.html_attribute_ids)
            for ha in  html_attributes
              if ha.is_special?(:image) or ha.is_special?(:src)
                hav= pv.html_attribute_value(ha)
                file_name = hav['pvalue0']
                if file_name
                  if spp.pclass==SectionPieceParam::PCLASS_STYLE
                    # replace ':' with '='
                    val << %Q!#{ha.perma_name}="#{build_path(file_name)}"!
                  else
                    val << "#{ha.perma_name}:url(#{build_path(file_name)});"
                  end
                end
              else
                unset = pv.unset?(ha.id)
                # should output hidden pv
                # hidden= pv.hidden?(ha.id)
                pv_for_ha = pv.pvalue_for_haid(ha.id)
                if !unset 
                  if spp.pclass==SectionPieceParam::PCLASS_STYLE
                    ha_perma_name, ha_value = pv_for_ha.split(':')
                    val << %Q!#{ha_perma_name}="#{ha_value}"!
                  else
                    val <<  ( pv_for_ha+';' )                    
                  end
                end                
              end
              
            end
    
          end
        end
      end
    end
Rails.logger.debug    " class_name={class_name}, val=#{val}"
    val
  end
  
  #Usage: get unique for current section piece instance
  def instance_id
    if self.section and self.section_piece
      "#{section['section_id']}_#{section['section_instance']}_#{section_piece['section_piece_id']}_#{section_piece['section_piece_instance']}"
    end
  end
  
  # parent section
  def parent_instance_id

  end  
  # parent section_piece
  def root_piece_instance_id
    if self.section and self.section_piece
      root_piece = Section.find(section_piece['root_id'])
#      Rails.logger.debug "root_piece=#{root_piece.inspect}"
      "#{section['section_id']}_#{section['section_instance']}_#{root_piece['section_piece_id']}_#{root_piece['section_piece_instance']}" #section_piece_instance always 1.  
    end
  end    
  
  def build_path(file_name)
    "/shops/#{::Rails.env}/#{1}/template_files/#{file_name}"
    
  end
  
end

class WebsitesTag < TagBase
  
  def website
    layout_generator.website
  end
  
  def get(function_name)
    self.website.send function_name
  end
  
  def public_path(target)
    File.join(layout_generator.layout_public_path,layout_generator.theme.file_name(target))
  end
  

end

#in layout, there are some eruby, all available varibles should be here.
class LayoutGenerator
  cattr_accessor :layout_base_path, :layout_public_path
  self.layout_public_path = File.join(File::SEPARATOR,"shops")
  self.layout_base_path = File.join(RAILS_ROOT,'public',layout_public_path)   
  cattr_accessor :pattern
  self.pattern = '<\? \?>'
  
  attr_accessor :website, :menu, :layout, :theme
  attr_accessor :layout_id, :theme_id
  attr_accessor :url_prefix
  attr_accessor :html, :css, :js
  #ruby embeded source
  attr_accessor :ehtml, :ecss, :ejs 
  #these attributes are for templates
  attr_accessor :param_values_tag, :websites_tag, :menus_tag
  attr_accessor :context
  attr_accessor :is_preview
  def initialize( param_theme_id,param_layout_id, param_menu_id=nil, options={})
    self.menu = Menu.find(param_menu_id) if param_menu_id
    self.layout = PageLayout.find(param_layout_id)
    self.theme = TemplateTheme.find(param_theme_id)
    self.website = self.theme.website
    self.layout_id, self.theme_id = param_layout_id, param_theme_id
    if options[:preview]
      self.url_prefix = "/erubis/preview"
    else
      self.url_prefix = "/erubis/example"
    end
    html = css = js = nil
    ehtml = ecss = ejs = nil
    #init template variables, used in templates
    self.is_preview = false
    self.param_values_tag = ParamValuesTag.new(self)    
    self.websites_tag = WebsitesTag.new(self)    
    self.menus_tag = MenusTag.new(self)    
    self.context = {:param_values=>param_values_tag,:website=>websites_tag, :menus=>menus_tag}  
  end
  

  #build html, css sourse
  def build
    self.ehtml, self.ecss = layout.build_content(theme.id)      
    return self.ehtml, self.ecss
  end
  
  #
  def generate
    if self.ehtml.nil? 
      self.build()
    end
    html_eruby = Erubis::Eruby.new(self.ehtml,:pattern=>self.class.pattern)
    self.html = html_eruby.evaluate(context)  
    css_eruby = Erubis::Eruby.new(self.ecss,:pattern=>self.class.pattern)
    self.css = css_eruby.evaluate(context)
    return self.html, self.css
  end
    
  def generate_from_erb(erb_html,erb_css = nil)
    self.ehtml = erb_html
    html_eruby = Erubis::Eruby.new(self.ehtml,:pattern=>self.class.pattern)
    self.html = html_eruby.evaluate(context) 
    
    return self.html, self.css
  end
    
  def init_availables
    
    
  end
  
end

