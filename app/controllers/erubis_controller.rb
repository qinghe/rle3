require 'erubis'
class ErubisController < ApplicationController
  cattr_accessor :layout_base_path
  self.layout_base_path = File.join(Rails.root,"public","shops")   

  def index
    @page_layouts = PageLayout.roots
  end
  
  def build
    layout_id = params[:layout_id]
    theme_id = params[:theme_id]
    html, css = "", ""
    if PageLayout.exists?(layout_id)
      theme = TemplateTheme.find(theme_id)
      @lg = LayoutGenerator.new(theme_id, layout_id)
      html, css = @lg.build
      path = File.join(self.layout_base_path, "e#{theme.file_name('html')}")
      open(path, 'w') do |f|  f.puts html; end
      path = File.join(self.layout_base_path, "e#{theme.file_name('css')}")
      open(path, 'w') do |f|  f.puts css; end      
    end
    
  end
  
  def publish    
    # find all theme used by website
    theme_ids = Menu.assigned_theme_ids()
    if not theme_ids.empty?
      for theme_id in theme_ids
        theme = TemplateTheme.find(theme_id)
        do_build(theme.id, theme.layout_id)
      end
    end
     render_message("yes, published!")
   
  end
  
  def content
    @page_layout = PageLayout.find(params[:layout_id])
  end
  
  
  # params for preview
  #    d: domain of website
  #    c: menu_id
  def preview
    #for debug
    params[:d] = 'www.rubyecommerce.com'
    
    the_website=the_menu=the_layout=the_theme = nil
    the_website = Website.find_by_url(params[:d])
    if params[:c]
      the_menu = Menu.find_by_id(params[:c])
    else
      the_menu = Menu.find_by_id(the_website.index_page)  
    end
    the_theme = TemplateTheme.find(the_menu.find_theme_id(is_preview=true))
    do_preview(the_theme.id, the_theme.layout_id, the_menu.id)
    render :text => File.read("#{Rails.public_path}/shops/#{the_theme.file_name('html')}")
  end
  
  
  
  def example
    params[:d] = 'www.rubyecommerce.com'
    
    the_website=the_menu=the_layout=the_theme = nil
    the_website = Website.find_by_url(params[:d])
    if params[:c]
      the_menu = Menu.find_by_id(params[:c])
    else
      the_menu = Menu.find_by_id(the_website.index_page)  
    end
    the_theme = TemplateTheme.find(the_menu.find_theme_id(is_preview=true))
    html, css = do_generate(the_theme.id, the_theme.layout_id, the_menu.id)
    render :text => html

  end
  
  # build ehtml,css,js
  def do_build( theme_id, layout_id, options={})
    options[:serialize_html] = true
    options[:serialize_css] = true
    
      theme = TemplateTheme.find(theme_id)
      @lg = LayoutGenerator.new( theme_id, layout_id)
      html, css = @lg.build
      if options[:serialize_html]
        path = File.join(self.layout_base_path, theme.file_name('ehtml'))      
        open(path, 'w') do |f|  f.puts html; end
      end
      html, css = @lg.generate
      if options[:serialize_css]      
        path = File.join(self.layout_base_path, theme.file_name('css'))
        open(path, 'w') do |f|  f.puts css; end
      end
      return html, css      
  end
  

  def do_generate( theme_id, layout_id, menu_id, options={})

      theme = TemplateTheme.find(theme_id)
      @lg = LayoutGenerator.new( theme_id, layout_id, menu_id, options)
      path = File.join(self.layout_base_path, theme.file_name('ehtml'))
      erb_html =  open(path) do |f|  f.read end
      html, css = @lg.generate_from_erb(erb_html)
      return html, css      
  end
  
  
end

