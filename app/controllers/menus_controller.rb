class MenusController < ApplicationController
  # GET /menus
  # GET /menus.xml
  def index
    @menus = Menu.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @menus }
    end
  end

  # GET /menus/1
  # GET /menus/1.xml
  def show
    @menu = Menu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @menu }
    end
  end

  # GET /menus/new
  # GET /menus/new.xml
  def new
    @menu = Menu.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @menu }
    end
  end

  # GET /menus/1/edit
  def edit
    @menu = Menu.find(params[:id])
  end


  def assign_template
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
  # POST /menus
  # POST /menus.xml
  def create
    @menu = Menu.new(params[:menu])
    @menu.perma_name = @menu.title.underscore
    respond_to do |format|
      if @menu.save
        format.html { redirect_to(@menu, :notice => 'Menu was successfully created.') }
        format.xml  { render :xml => @menu, :status => :created, :location => @menu }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /menus/1
  # PUT /menus/1.xml
  def update
    @menu = Menu.find(params[:id])

    respond_to do |format|
      if @menu.update_attributes(params[:menu])
        format.html { redirect_to(@menu, :notice => 'Menu was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.xml
  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy

    respond_to do |format|
      format.html { redirect_to(menus_url) }
      format.xml  { head :ok }
    end
  end
end
