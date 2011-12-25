class SectionPieceParamsController < ApplicationController
  # GET /section_piece_params
  # GET /section_piece_params.xml
  def index
    @section_piece_params = SectionPieceParam.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @section_piece_params }
    end
  end

  # GET /section_piece_params/1
  # GET /section_piece_params/1.xml
  def show
    @section_piece_param = SectionPieceParam.find(params[:id])
      
    @html_attributes = HtmlAttribute.find(@section_piece_param.html_attribute_ids.split(','))
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @section_piece_param }
    end
  end

  # GET /section_piece_params/new
  # GET /section_piece_params/new.xml
  def new
    @section_piece_param = SectionPieceParam.new
    @html_attributes = HtmlAttribute.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @section_piece_param }
    end
  end

  # GET /section_piece_params/1/edit
  def edit
    @section_piece_param = SectionPieceParam.find(params[:id])
    @html_attributes = HtmlAttribute.all
  end

  # POST /section_piece_params
  # POST /section_piece_params.xml
  def create
    @section_piece_param = SectionPieceParam.new(params[:section_piece_param])
    @section_piece_param['html_attribute_ids'] = params[:html_attribute_ids].join(',') 
    respond_to do |format|
      if @section_piece_param.save
        format.html { redirect_to(@section_piece_param, :notice => 'SectionPieceParam was successfully created.') }
        format.xml  { render :xml => @section_piece_param, :status => :created, :location => @section_piece_param }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @section_piece_param.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /section_piece_params/1
  # PUT /section_piece_params/1.xml
  def update
    @section_piece_param = SectionPieceParam.find(params[:id])
    @section_piece_param['html_attribute_ids'] = params[:html_attribute_ids].join(',') 

    respond_to do |format|
      if @section_piece_param.update_attributes(params[:section_piece_param])
        format.html { redirect_to(@section_piece_param, :notice => 'SectionPieceParam was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @section_piece_param.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /section_piece_params/1
  # DELETE /section_piece_params/1.xml
  def destroy
    @section_piece_param = SectionPieceParam.find(params[:id])
    @section_piece_param.destroy

    respond_to do |format|
      format.html { redirect_to(section_piece_params_url) }
      format.xml  { head :ok }
    end
  end
end
