class TemplateFilesController < ApplicationController
  # GET /template_files
  # GET /template_files.xml
  def index
    @template_files = UpdatedImage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @template_files }
    end
  end

  # GET /template_files/1
  # GET /template_files/1.xml
  def show
    @uploaded_image = UpdatedImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @uploaded_image }
    end
  end

  # GET /template_files/new
  # GET /template_files/new.xml
  def new
    @uploaded_image = UpdatedImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @uploaded_image }
    end
  end

  # GET /template_files/1/edit
  def edit
    @uploaded_image = UpdatedImage.find(params[:id])
  end

  # POST /template_files
  # POST /template_files.xml
  def create
    @uploaded_image = UpdatedImage.new(params[:uploaded_image])

    respond_to do |format|
      if @uploaded_image.save
        format.html { redirect_to(@uploaded_image, :notice => 'UpdatedImage was successfully created.') }
        format.xml  { render :xml => @uploaded_image, :status => :created, :location => @uploaded_image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @uploaded_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /template_files/1
  # PUT /template_files/1.xml
  def update
    @uploaded_image = UpdatedImage.find(params[:id])

    respond_to do |format|
      if @uploaded_image.update_attributes(params[:uploaded_image])
        format.html { redirect_to(@uploaded_image, :notice => 'UpdatedImage was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @uploaded_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /template_files/1
  # DELETE /template_files/1.xml
  def destroy
    @uploaded_image = UpdatedImage.find(params[:id])
    @uploaded_image.destroy

    respond_to do |format|
      format.html { redirect_to(template_files_url) }
      format.xml  { head :ok }
    end
  end
end
