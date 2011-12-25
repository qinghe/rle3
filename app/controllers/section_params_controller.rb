class SectionParamsController < ApplicationController
  # GET /section_params
  # GET /section_params.xml
  def index
    @section_params = SectionParam.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @section_params }
    end
  end

  # GET /section_params/1
  # GET /section_params/1.xml
  def show
    @section_param = SectionParam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @section_param }
    end
  end

  # GET /section_params/new
  # GET /section_params/new.xml
  def new
    @section_param = SectionParam.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @section_param }
    end
  end

  # GET /section_params/1/edit
  def edit
    @section_param = SectionParam.find(params[:id])
  end

  # POST /section_params
  # POST /section_params.xml
  def create
    @section_param = SectionParam.new(params[:section_param])

    respond_to do |format|
      if @section_param.save
        format.html { redirect_to(@section_param, :notice => 'SectionParam was successfully created.') }
        format.xml  { render :xml => @section_param, :status => :created, :location => @section_param }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @section_param.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /section_params/1
  # PUT /section_params/1.xml
  def update
    @section_param = SectionParam.find(params[:id])

    respond_to do |format|
      if @section_param.update_attributes(params[:section_param])
        format.html { redirect_to(@section_param, :notice => 'SectionParam was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @section_param.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /section_params/1
  # DELETE /section_params/1.xml
  def destroy
    @section_param = SectionParam.find(params[:id])
    @section_param.destroy

    respond_to do |format|
      format.html { redirect_to(section_params_url) }
      format.xml  { head :ok }
    end
  end
end
