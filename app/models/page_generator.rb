#in layout, there are some eruby, all available varibles should be here.
class PageGenerator
  cattr_accessor :layout_base_path, :layout_public_path
  self.layout_public_path = File.join(File::SEPARATOR,"shops")
  self.layout_base_path = File.join(Rails.root,'public',layout_public_path)   
  cattr_accessor :pattern
  self.pattern = '<\? \?>'
  
  attr_accessor :website, :menu, :theme, :resource # resource could be blog_post, flash, file, image...
  attr_accessor :editor
  attr_accessor :url_prefix
  attr_accessor :html, :css, :js
  #ruby embeded source
  attr_accessor :ehtml, :ecss, :ejs 
  #these attributes are for templates
  attr_accessor :current_page_tag
  attr_accessor :context
  attr_accessor :is_preview
  
  class << self
    #page generator has two interface, builder and generator
    #builder only build content: ehtml,js,css
    def builder( theme )
      self.new( theme, menu=nil)      
    end
    
    #generator generate content: html,js,css
    def generator(menu, theme=nil,  options={})
      self.new( theme, menu, options)
    end
  end
  
  def initialize( theme, menu, options={})
    self.menu = menu
    self.theme = theme
    self.resource = nil
    if options[:preview_url]
      self.url_prefix = "/preview"
    else
      self.url_prefix = "/erubis/example"
    end
    
    self.editor = options[:editor]
    if options[:blog_post_id]
      self.resource = BlogPost.find(options[:blog_post_id])
    end
    html = css = js = nil
    ehtml = ecss = ejs = nil
    #init template variables, used in templates
    self.is_preview = false
    self.current_page_tag =   PageTag::CurrentPage.new(self)
    initialize_context_variables
      
  end
  
  def has_editor?
    self.editor.present?
  end

  #build html, css sourse
  def build
    self.ehtml, self.ecss = self.theme.page_layout.build_content()      
    return self.ehtml, self.ecss
  end
  
  #
  def generate
    if self.ehtml.nil? 
      self.build()
    end
    html_eruby = Erubis::Eruby.new(self.ehtml,:pattern=>self.class.pattern)
    self.html = html_eruby.evaluate(context)  
    return self.html
  end

  #generate css and js, they are do not need current menu
  def generate_assets
    if self.ecss.nil? 
      self.build()
    end
    css_eruby = Erubis::Eruby.new(self.ecss,:pattern=>self.class.pattern)
    self.css = css_eruby.evaluate(context)
    return self.css, self.js
  end
    
  def generate_from_erb_file()
    path = File.join(self.class.layout_base_path, self.theme.file_name('ehtml'))
    erb_html =  open(path) do |f|  f.read end
    
    self.ehtml = erb_html
    html_eruby = Erubis::Eruby.new(self.ehtml,:pattern=>self.class.pattern)
    self.html = html_eruby.evaluate(context) 
    
    return self.html, self.css
  end
    
 
  def build_path(model)    
    url = nil
    if model.kind_of?( Menu)
      url= [self.url_prefix, model.id].join('/')
    else  
      url= [self.url_prefix, self.menu.id, model.id].join('/')    
    end    
    url
  end
  
  # *specific_attribute - ehtml,ecss, html, css
  def serialize_page(specific_attribute)
    specific_attribute_collection = [:html,:css,:js,:ehtml,:ecss,:ejs]
    raise ArgumentError unless specific_attribute_collection.include?(specific_attribute)
    page_content = send(specific_attribute)
    if page_content.present?
      path = File.join(self.class.layout_base_path, self.theme.file_name('ehtml'))      
      open(path, 'w') do |f|  f.puts html; end
    end
    
  end


  private
  # erb context variables 
  def initialize_context_variables
    self.context = {:current_page=>current_page_tag, 
      :website=>current_page_tag.website_tag, :template=>current_page_tag.template_tag
      }    
  end  
end

