#in layout, there are some eruby, all available varibles should be here.
class PageGenerator
  cattr_accessor :layout_base_path, :layout_public_path
  self.layout_public_path = File.join(File::SEPARATOR,"shops")
  self.layout_base_path = File.join(Rails.root,'public',layout_public_path)   
  cattr_accessor :pattern
  self.pattern = '<\? \?>'
  
  attr_accessor :website, :menu, :layout, :theme, :resource # resource could be blog_post, flash, file, image...
  attr_accessor :layout_id, :theme_id, :editor
  attr_accessor :url_prefix
  attr_accessor :html, :css, :js
  #ruby embeded source
  attr_accessor :ehtml, :ecss, :ejs 
  #these attributes are for templates
  attr_accessor :param_values_tag, :website_tag, :menus_tag, :current_page_tag
  attr_accessor :context
  attr_accessor :is_preview
  def initialize( param_theme_id,param_layout_id, param_menu_id, options={})
    self.menu = Menu.find(param_menu_id) 
    self.layout = PageLayout.find(param_layout_id)
    self.theme = TemplateTheme.find(param_theme_id)
    self.website = self.theme.website
    self.layout_id, self.theme_id = param_layout_id, param_theme_id
    if options[:preview_url]
      self.url_prefix = "/preview"
    else
      self.url_prefix = "/erubis/example"
    end
    
    self.editor = options[:editor]
    self.resource = nil
    if options[:blog_post_id]
      self.resource = BlogPost.find(options[:blog_post_id])
    end
    html = css = js = nil
    ehtml = ecss = ejs = nil
    #init template variables, used in templates
    self.is_preview = false
    self.param_values_tag = PageTag::ParamValues.new(self)    
    self.website_tag = PageTag::Website.new(self)    
    self.menus_tag = PageTag::Menus.new(self)    
    self.context = {:param_values=>param_values_tag,:website=>website_tag, :menus=>menus_tag}  
  end
  
  def has_editor?
    self.editor.present?
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
    
  def generate_from_erb_file()
    path = File.join(self.class.layout_base_path, self.theme.file_name('ehtml'))
    erb_html =  open(path) do |f|  f.read end
    
    self.ehtml = erb_html
    html_eruby = Erubis::Eruby.new(self.ehtml,:pattern=>self.class.pattern)
    self.html = html_eruby.evaluate(context) 
    
    return self.html, self.css
  end
    
  def init_availables
    
    
  end
  
  def build_url(options={})
    menu_id = options[:menu_id]
    blog_post_id = options[:blog_post_id]  
    url= self.url_prefix+"/#{menu_id}"
    url<< "/#{blog_post_id}" if blog_post_id
    url
  end
  
  # *specific_attribute - ehtml,ecss, html, css
  def serialize_page(specific_attribute)
    specific_attribute_collection = [:html,:css,:js,:ehtml,:ecss,:ejs]
    raise ArgumentError unlessspecific_attribute_collection.include?(specific_attribute)
    page_content = send(file_type)
    if page_content.present?
      path = File.join(self.class.layout_base_path, self.theme.file_name('ehtml'))      
      open(path, 'w') do |f|  f.puts html; end
    end
    
  end
  
end

