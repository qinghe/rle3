class TemplateThemesController < ApplicationController
  cattr_accessor :layout_base_path
  self.layout_base_path = File.join(::Rails.root.to_s,"public","shops")   

  # GET /themes
  # GET /themes.xml
  def index
    @themes = TemplateTheme.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @themes }
    end
  end

  # GET /themes/1
  # GET /themes/1.xml
  def show
    @theme = TemplateTheme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @theme }
    end
  end

  #copy selected theme to new theme
  def copy
    @original_theme = TemplateTheme.find(params[:id])
    #copy theme, layout, param_value
    @new_theme = @original_theme.copy_to_new
    
    respond_to do |format|
      format.html { redirect_to(template_themes_url) }
    end    
  end
  # GET /themes/new
  # GET /themes/new.xml
  def new
    @theme = TemplateTheme.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @theme }
    end
  end

  # GET /themes/1/edit
  def edit
    @theme = TemplateTheme.find(params[:id])
  end

  # POST /themes
  # POST /themes.xml
  def create
    @theme = TemplateTheme.new(params[:theme])

    respond_to do |format|
      if @theme.save
        format.html { redirect_to(@theme, :notice => 'TemplateTheme was successfully created.') }
        format.xml  { render :xml => @theme, :status => :created, :location => @theme }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /themes/1
  # PUT /themes/1.xml
  def update
    @theme = TemplateTheme.find(params[:id])

    respond_to do |format|
      if @theme.update_attributes(params[:theme])
        format.html { redirect_to(@theme, :notice => 'TemplateTheme was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /themes/1
  # DELETE /themes/1.xml
  def destroy
    @theme = TemplateTheme.find(params[:id])
    @theme.destroy

    respond_to do |format|
      format.html { redirect_to(template_themes_url) }
      format.xml  { head :ok }
    end
  end
  
  def build
    theme_id = params[:id]
    html, css = "", ""
    if TemplateTheme.exists?(theme_id)
      theme = TemplateTheme.find(theme_id)
      @lg = PageGenerator.builder(theme)
      html,css = @lg.build
      @lg.serialize_page(:ehtml)      
      @lg.serialize_page(:ecss)      
    end
  end
 
  
  # params for preview
  #    d: domain of website
  #    c: menu_id
  def preview
    #for debug
    params[:d] = 'www.rubyecommerce.com'
    editor = params[:editor]
    website=menu=layout=theme = resource = nil
    website = Website.find_by_url(params[:d])
    if params[:c]
      menu = Menu.find_by_id(params[:c])
      if params[:r]
        resource = BlogPost.find_by_id(params[:r])
      end  
    else
      menu = Menu.find_by_id(website.index_page)  
    end
    theme = TemplateTheme.find(menu.find_theme_id(is_preview=true))
    html,css = do_preview(theme, menu, {:blog_post_id=>(resource.nil? ? nil:resource.id),:editor=>editor})
    #insert css to html
    style = %Q!<style type="text/css">#{css}</style>!
    html.insert(html.index("</head>"),style)
    render :text => html
  end
    
  def publish
    @menu = Menu.roots.first
  end
  
  def assign_default
    website_params = params[:website]
    self.website[:index_page] = website_params[:index_page].to_i
    self.website.save
    render_message("yes, updated!")    
    
  end
  
  def assign
    # "commit"=>[Update&Preview|Update|Preview]
    commit_command = params[:commit]
    keys = params.keys.select{|k|k=~/menu[\d]+/}
    menus_params = params.values_at(*keys)
    
    if commit_command=~/Update/
      #update default page
      website_params = params[:website]
      self.website.attributes = website_params
      self.website.save
      
    end
    
    if commit_command=~/Publish/
      do_publish
    end
    
    
    respond_to do |format|
      format.js  {
        if commit_command=~/Preview/
          render "preview"          
        else# commit_command=~/Publish/
          render_message("yes, publish")
        end    
      }
    end   

  end
  
  def select_tree
    
    @menu = Menu.find(params[:menu_id])
    
    render :partial=>"menu_and_template"
  end
  
  def edit_layout
    
  end
    
  def editor
    theme_id = 0
    layout_id = 0
    theme = TemplateTheme.find(params[:id])
    prepare_params_for_editors(theme)
    
    @template_themes = TemplateTheme.all
  end  

  def update_layout_tree
    op = params[:op]
    layout_id = params[:layout_id]
    selected_id = params[:selected_id]
    selected_type = params[:selected_type]
    layout = PageLayout.find(layout_id)
    @layout = layout.root
    if op=='move_left'
      layout.move_left
    elsif op=='move_right'  
      layout.move_right
    elsif op=='add_child'    
      if selected_type=='Section'  
        layout.add_section(selected_id)
      else
        layout.add_layout_tree(selected_id)        
      end
      @layout.reload      
    elsif op=='del_self'
      layout.destroy unless layout.root?        
      @layout.reload
    end
    
    render :partial=>"layout_tree"    
  end

  # user disable a section in the current layout tree
  def disable_section
    layout_id = params[:layout_id]
    layout = PageLayout.find(layout_id)
    se = PageEvent::SectionEvent.new("disable_section", layout )
    se.notify
    
  end
  
  def get_param_values
    theme_id = params[:selected_theme_id]
    editor_id = params[:selected_editor_id]
    layout_id = params[:selected_page_layout_id]
        
    theme = TemplateTheme.find(theme_id)
    editor = Editor.find(editor_id)
    page_layout = PageLayout.find(layout_id) 
    prepare_params_for_editors(theme, editor, page_layout)
    
    respond_to do |format|
      format.html 
      format.js  {render :partial=>'editors'}
    end    
  end

  #FIXME, fix do_update_param_value
  def update_param_values
    selected_theme_id = params[:selected_theme_id]
    selected_editor_id = params[:selected_editor_id]
    param_value_keys = params.keys.select{|k| k=~/pv[\d]+/}
    
    for pvk in param_value_keys
      param_value_params = params[pvk]
      pv_id = pvk[/\d+/].to_i
      param_value = ParamValue.find(pv_id, :include=>[:section_param, :section])
      do_update_param_value(param_value, param_value_params) 
    end
    
  end
  
  def update_param_value
    param_value_event = params[:param_value_event]
    editing_param_value_id = params[:editing_param_value_id].to_i
    editing_html_attribute_id = params[:editing_html_attribute_id].to_i
    theme_id = params[:selected_theme_id]
    editor_id = params[:selected_editor_id]
    layout_id = params[:selected_page_layout_id]
    param_value_keys = params.keys.select{|k| k=~/pv[\d]+/}
    
      param_value_params = params["pv#{editing_param_value_id}"]
      source_param_value = ParamValue.find(editing_param_value_id, :include=>[:section_param, :section])
      updated_html_attribute_values = do_update_param_value(source_param_value, param_value_params, param_value_event, editing_html_attribute_id)

    #  param_value = ParamValue.find(editing_param_value_id)
    theme = TemplateTheme.find(theme_id)  
    editor = Editor.find(editor_id)
    page_layout = PageLayout.find(layout_id) 
    prepare_params_for_editors(theme,editor,page_layout)
   
    respond_to do |format|
      format.html 
      format.js  {render :partial=>'update_param_value',:locals=>{:source_param_value=>source_param_value,:updated_html_attribute_values=>updated_html_attribute_values}}
    end    
    
  end
  
    
  def prepare_params_for_editors(theme,editor=nil,page_layout = nil)
    @editors = Editor.all
    @param_values_for_editors = Array.new(@editors.size){|i| []}
    editor_ids = @editors.collect{|e|e.id}
    page_layout ||= theme.page_layout
    param_values =theme.param_values().where(:page_layout_id=>page_layout.id).includes([:section_param=>[:section_piece_param=>:param_category]]) 
    #get param_values for each editors
    for pv in param_values
      #only get pv blong to root section
      #next if pv.section_id != layout.section_id or pv.section_instance != layout.section_instance
      idx = (editor_ids.index pv.section_param.section_piece_param.editor_id)
      if idx>=0
        @param_values_for_editors[idx]||=[]        
        @param_values_for_editors[idx] << pv
      end
    end 

    @theme =  theme   
    @editor = editor    
    @editor ||= @editors.first
    
    @page_layout = page_layout #current selected page_layout, the node of the layout tree.
    @page_layout||= theme.page_layout
  end
  
  # Usage, update a param_value by param_value_param
  # Params, param_value ParamValue instance 
  #         param_value_params, hash, format as {"84"=>{"pvalue"=>"section_name", "psvalue"=>"0t"}}
  # Return, all updated_html_attribute_values, may include html_attribute_value belongs to other section, also include the source change, it is the first,
  #         it cause the serial changes.
  def do_update_param_value(param_value, param_value_params, param_value_event, editing_html_attribute_id)
    html_attribute = html_attribute_value_params = nil 
    param_value_params.keys.each {|ha_id|
      ha_id = ha_id.to_i
      if editing_html_attribute_id.nil? or editing_html_attribute_id==ha_id
        html_attribute = HtmlAttribute.find_by_ids(ha_id)
        html_attribute_value_params = param_value_params[ha_id.to_s]
        #event_params = {:html_attribute=>html_attribute,:html_attribute_value_params=>html_attribute_value_params}
        #param_value.raise_event(param_value_event, event_params)
      end      
    }
    param_value.update_html_attribute_value(html_attribute, html_attribute_value_params, param_value_event )
    #param_value.save
    param_value.updated_html_attribute_values
  end
  
  def upload_file_dialog
    @dialog_content="upload_dialog_content"
    @param_value_id = params[:param_value_id]
    @html_attribute_id = params[:html_attribute_id].to_i
@param_value = ParamValue.find(@param_value_id, :include=>[:section_param=>:section_piece_param])
@editor = @param_value.section_param.section_piece_param.editor
    if request.post?
      
      uploaded_image = TemplateFile.new( params[:template_file] )
      if uploaded_image.valid?
        uploaded_image['layout_id']=@param_value.layout_id
        uploaded_image['theme_id']=@param_value.theme_id              
        if uploaded_image.save
logger.debug "uploaded_image = #{uploaded_image.inspect}"          
              # update param value to selected uploaded image
              param_value_params={@html_attribute_id.to_s=>{"unset"=>"0", "pvalue0"=>uploaded_image.file_name, "psvalue0"=>"0i"}}
              param_value_event = ParamValue::EventEnum[:pv_changed]
              editing_html_attribute_id = @html_attribte_id
              do_update_param_value(@param_value, param_value_params, param_value_event, editing_html_attribute_id) 
              # get all param values by selected editor
              # since we redirect to editors, these are unused
              @param_values = @param_value.template_theme.full_param_values(@editor.id)
              # update param value
              render :partial=>'after_upload_dialog' 
        end
      else
        
      end
    else

      @theme = TemplateTheme.find(@param_value.theme_id)

      model_dialog("File upload dialog",@dialog_content)    

    end
  end
  
  
  
  def check_upload_file_name
    file_name = params[:file_name]
    is_existing = TemplateFile.exists?( ["file_name=?", file_name])
    if is_existing
      # render "replace"
    else
      # render "upload"      
    end
  end
  
  def do_publish
      # find all theme used by website
    theme_ids = Menu.assigned_theme_ids()
    if not theme_ids.empty?
      for theme_id in theme_ids
        theme = TemplateTheme.find(theme_id)
        do_build(theme)
      end
    end
  end
  
    # build ehtml,css,js
  def do_build( theme, options={})
    options[:serialize_ehtml] = true
    options[:serialize_ecss] = true
    
      @lg = PageGenerator.builder( theme)
      html, css = @lg.build
      if options[:serialize_ehtml]
        @lg.serialize_page(:ehtml)
      end
      css = @lg.generate_assets
      if options[:serialize_css]      
        @lg.serialize_page(:css)
      end
      return html, css      
  end
  
  def do_preview( theme,  menu, options={})
      options[:preview_url] = true #preview_template_themes_url
      @lg = PageGenerator.generator( menu, theme, options)
      html = @lg.generate
      css,js  = @lg.generate_assets
      if options[:serialize_html]
        @lg.serialize_page(:html)
      end
      if options[:serialize_css]      
        @lg.serialize_page(:css)
      end
      return html, css, js  
  end

  def do_generate( theme_id, layout_id, menu_id, options={})

      theme = TemplateTheme.find(theme_id)
      @lg = PageGenerator.new( theme_id, layout_id, menu_id, options)
      html, css = @lg.generate_from_erb_file
      return html, css      
  end
    
  def public
    params[:d] = 'www.rubyecommerce.com'
    
    website=menu=layout=theme = nil
    website = Website.find_by_url(params[:d])
    if params[:c]
      menu = Menu.find_by_id(params[:c])
    else
      menu = Menu.find_by_id(website.index_page)  
    end
    theme = TemplateTheme.find(menu.find_theme_id(is_preview=true))
    html, css = do_generate(theme.id, theme.layout_id, menu.id)
    render :text => html

  end
    
    
end
