class PageLayoutsController < ApplicationController
  # GET /page_layouts
  # GET /page_layouts.xml
  def index
    @page_layouts = PageLayout.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @page_layouts }
    end
  end

  # GET /page_layouts/1
  # GET /page_layouts/1.xml
  def show
    @page_layout = PageLayout.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page_layout }
    end
  end

  # GET /page_layouts/new
  # GET /page_layouts/new.xml
  def new
    @page_layout = PageLayout.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page_layout }
    end
  end

  # GET /page_layouts/1/edit
  def edit
    @page_layout = PageLayout.find(params[:id])
  end

  
  def content
    @page_layout = PageLayout.find(params[:id])
  end
  # POST /page_layouts
  # POST /page_layouts.xml
  def create
    param_page_layout = params[:page_layout]
    param_page_layout[:root_id] = 0 if param_page_layout[:root_id].empty?
    param_page_layout[:parent_id] = 0 if param_page_layout[:parent_id].empty?
          
    @page_layout = PageLayout.new(param_page_layout)
    is_saved = @page_layout.save
    if @page_layout.root_id==0
      @page_layout.update_attribute(:root_id, @page_layout[:id])
    end
    
    respond_to do |format|
      if @page_layout.save
        format.html { redirect_to(:action=>"show",:id=>@page_layout, :notice => 'PageLayout was successfully created.') }
        format.xml  { render :xml => @page_layout, :status => :created, :location => @page_layout }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page_layout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /page_layouts/1
  # PUT /page_layouts/1.xml
  def update
    @page_layout = PageLayout.find(params[:id])

    respond_to do |format|
      if @page_layout.update_attributes(params[:page_layout])
        format.html { redirect_to(@page_layout, :notice => 'PageLayout was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page_layout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /page_layouts/1
  # DELETE /page_layouts/1.xml
  def destroy
    @page_layout = PageLayout.find(params[:id])
    @page_layout.destroy

    respond_to do |format|
      format.html { redirect_to(page_layouts_url) }
      format.xml  { head :ok }
    end
  end

  
end
