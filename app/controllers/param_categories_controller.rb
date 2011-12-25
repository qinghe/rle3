class ParamCategoriesController < ApplicationController
  # GET /param_categories
  # GET /param_categories.xml
  def index
    @param_categories = ParamCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @param_categories }
    end
  end

  # GET /param_categories/1
  # GET /param_categories/1.xml
  def show
    @param_category = ParamCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @param_category }
    end
  end

  # GET /param_categories/new
  # GET /param_categories/new.xml
  def new
    @param_category = ParamCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @param_category }
    end
  end

  # GET /param_categories/1/edit
  def edit
    @param_category = ParamCategory.find(params[:id])
  end

  # POST /param_categories
  # POST /param_categories.xml
  def create
    @param_category = ParamCategory.new(params[:param_category])

    respond_to do |format|
      if @param_category.save
        format.html { redirect_to(@param_category, :notice => 'ParamCategory was successfully created.') }
        format.xml  { render :xml => @param_category, :status => :created, :location => @param_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @param_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /param_categories/1
  # PUT /param_categories/1.xml
  def update
    @param_category = ParamCategory.find(params[:id])

    respond_to do |format|
      if @param_category.update_attributes(params[:param_category])
        format.html { redirect_to(@param_category, :notice => 'ParamCategory was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @param_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /param_categories/1
  # DELETE /param_categories/1.xml
  def destroy
    @param_category = ParamCategory.find(params[:id])
    @param_category.destroy

    respond_to do |format|
      format.html { redirect_to(param_categories_url) }
      format.xml  { head :ok }
    end
  end
end
