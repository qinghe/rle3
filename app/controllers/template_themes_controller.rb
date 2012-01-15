class TemplateThemesController < ApplicationController
  cattr_accessor :layout_base_path
  self.layout_base_path = File.join(RAILS_ROOT,"public","shops")   

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
      format.html { redirect_to(themes_url) }
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
      format.html { redirect_to(themes_url) }
      format.xml  { head :ok }
    end
  end
  
  # params for preview
  #    d: domain of website
  #    c: menu_id
  def preview
    #for debug
    params[:d] = 'www.rubyecommerce.com'
    
    the_website=the_menu=the_layout=the_theme = nil
    the_website = Website.find_by_url(params[:d])
    if params[:id]
      the_menu = Menu.find_by_id(params[:id])
    else
      the_menu = Menu.find_by_id(the_website.index_page)  
    end
    the_theme = TemplateTheme.find(the_menu.find_theme_id(is_preview=true))
    html,css = do_preview(the_theme.id, the_theme.layout_id, the_menu.id)
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
      self.website[:index_page] = website_params[:index_page].to_i
      self.website.save
      #update all pages.
      for menu in Menu.roots
        menu_params = params["menu#{menu.id}"]
        if menu_params
          menu.inheritance = menu_params[:inheritance]
          if menu.inheritance
            for item in menu.self_and_descendants
              item_params = params["menu#{item.id}"]          
              item.theme_id = item_params[:theme_id].to_i
              item.detail_theme_id = item_params[:detail_theme_id].to_i
              item.ptheme_id = item_params[:ptheme_id].to_i
              item.pdetail_theme_id = item_params[:pdetail_theme_id].to_i
              item.save
            end        
          else
            levels = []
            menu_for_levels = {}
            Menu.each_with_level(menu.self_and_descendants) do |o, level|
              next if levels.include? level
              levels << level
              menu_for_levels[level] =  o
            end
            
            for level in levels
              item = menu_for_levels[level]
              item_params = params["menu#{menu.id}_level#{level}"]
              if item.menu_level.nil?
                item_params['level'] = level
                item.create_menu_level(item_params)
              else
                item.menu_level.update_attributes(item_params)
              end
            end
              
          end
          menu.save
        end
      end
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
    
  def editor
    theme_id = 0
    layout_id = 0
    theme = TemplateTheme.find(params[:id])
    prepare_params_for_editors(theme)
    
    @layout_roots = PageLayout.roots
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
    se = SectionEvent.new("disable_section", layout )
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
  
  
  def test_create_layout
   # PageLayout.delete_all              
    objects = Section.roots
    section_hash= objects.inject({}){|h,sp| h[sp.perma_name] = sp; h}
    puts "section_hash=#{section_hash.keys}"
    root = PageLayout.create_layout(section_hash['root'].id, :perma_name=>"layout1")
    header = root.add_section(section_hash['container'].id)
    body = root.add_section(section_hash['container'].id)
    footer = root.add_section(section_hash['container'].id)
    body.add_section(section_hash['menu'].id)

  end
  
  def prepare_params_for_editors(theme,editor=nil,page_layout = nil)
    @editors = Editor.all
    @param_values_for_editors = Array.new(@editors.size){|i| []}
    editor_ids = @editors.collect{|e|e.id}
    page_layout ||= theme.page_layout
    #get param_values for each editors
    for pv in page_layout.param_values(theme.id)
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
  def do_update_param_value(param_value, param_value_params, param_value_event=nil, editing_html_attribute_id=nil) 
    param_value_params.keys.each {|ha_id|
      ha_id = ha_id.to_i
      if editing_html_attribute_id.nil? or editing_html_attribute_id==ha_id
        html_attribute = HtmlAttribute.find_by_ids(ha_id)
        html_attribute_value_params = param_value_params[ha_id.to_s]
        event_params = {:html_attribute=>html_attribute,:html_attribute_value_params=>html_attribute_value_params}
        param_value.raise_event(param_value_event, event_params)
      end      
    }
    param_value.save
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
              @param_values = @param_value.page_layout.param_values(@param_value.theme_id, @editor.id)
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
        do_build(theme.id, theme.layout_id)
      end
    end
  end
  
    # build ehtml,css,js
  def do_build( theme_id, layout_id, options={})
    options[:serialize_html] = true
    options[:serialize_css] = true
    
      theme = TemplateTheme.find(theme_id)
      @lg = LayoutGenerator.new( theme_id, layout_id)
      html, css = @lg.build
      if options[:serialize_html]
        path = File.join(LayoutGenerator.layout_base_path, theme.file_name('ehtml'))      
        open(path, 'w') do |f|  f.puts html; end
      end
      html, css = @lg.generate
      if options[:serialize_css]      
        path = File.join(LayoutGenerator.layout_base_path, theme.file_name('css'))
        open(path, 'w') do |f|  f.puts css; end
      end
      return html, css      
  end
  
  def do_preview( theme_id, layout_id, menu_id, options={})
      options[:preview_url] = preview_template_themes_url
      theme = TemplateTheme.find(theme_id)
      @lg = LayoutGenerator.new( theme_id, layout_id, menu_id, options)
      html, css = @lg.generate
      if options[:serialize_html]
        path = File.join(LayoutGenerator.layout_base_path, theme.file_name('html'))      
        open(path, 'w') do |f|  f.puts html; end
      end
      if options[:serialize_css]      
        path = File.join(self.layout_base_path, theme.file_name('css'))
        open(path, 'w') do |f|  f.puts css; end
      end
      return html, css  
  end

  def do_generate( theme_id, layout_id, menu_id, options={})

      theme = TemplateTheme.find(theme_id)
      @lg = LayoutGenerator.new( theme_id, layout_id, menu_id, options)
      path = File.join(LayoutGenerator.layout_base_path, theme.file_name('ehtml'))
      erb_html =  open(path) do |f|  f.read end
      html, css = @lg.generate_from_erb(erb_html)
      return html, css      
  end
    
  def public
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
    
    
end
