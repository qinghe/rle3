class ParamValuesController < ApplicationController
  # GET /param_values
  # GET /param_values.xml
  def index
    @param_values = ParamValue.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @param_values }
    end
  end

  # GET /param_values/1
  # GET /param_values/1.xml
  def show
    @param_value = ParamValue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @param_value }
    end
  end

  # GET /param_values/new
  # GET /param_values/new.xml
  def new
    @param_value = ParamValue.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @param_value }
    end
  end

  # GET /param_values/1/edit
  def edit
    @param_value = ParamValue.find(params[:id])
  end

  # POST /param_values
  # POST /param_values.xml
  def create
    @param_value = ParamValue.new(params[:param_value])

    respond_to do |format|
      if @param_value.save
        format.html { redirect_to(@param_value, :notice => 'ParamValue was successfully created.') }
        format.xml  { render :xml => @param_value, :status => :created, :location => @param_value }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @param_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /param_values/1
  # PUT /param_values/1.xml
  def update
    @param_value = ParamValue.find(params[:id])

    respond_to do |format|
      if @param_value.update_attributes(params[:param_value])
        format.html { redirect_to(@param_value, :notice => 'ParamValue was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @param_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /param_values/1
  # DELETE /param_values/1.xml
  def destroy
    @param_value = ParamValue.find(params[:id])
    @param_value.destroy

    respond_to do |format|
      format.html { redirect_to(param_values_url) }
      format.xml  { head :ok }
    end
  end
  
  
end
