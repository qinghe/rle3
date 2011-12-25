class SectionPiecesController < ApplicationController
  # GET /section_pieces
  # GET /section_pieces.xml
  def index
    @section_pieces = SectionPiece.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @section_pieces }
    end
  end

  # GET /section_pieces/1
  # GET /section_pieces/1.xml
  def show
    @section_piece = SectionPiece.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @section_piece }
    end
  end

  # GET /section_pieces/new
  # GET /section_pieces/new.xml
  def new
    @section_piece = SectionPiece.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @section_piece }
    end
  end

  # GET /section_pieces/1/edit
  def edit
    @section_piece = SectionPiece.find(params[:id])
  end

  # POST /section_pieces
  # POST /section_pieces.xml
  def create
    @section_piece = SectionPiece.new(params[:section_piece])

    respond_to do |format|
      if @section_piece.save
        format.html { redirect_to(@section_piece, :notice => 'SectionPiece was successfully created.') }
        format.xml  { render :xml => @section_piece, :status => :created, :location => @section_piece }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @section_piece.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /section_pieces/1
  # PUT /section_pieces/1.xml
  def update
    @section_piece = SectionPiece.find(params[:id])

    respond_to do |format|
      if @section_piece.update_attributes(params[:section_piece])
        format.html { redirect_to(@section_piece, :notice => 'SectionPiece was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @section_piece.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /section_pieces/1
  # DELETE /section_pieces/1.xml
  def destroy
    @section_piece = SectionPiece.find(params[:id])
    @section_piece.destroy

    respond_to do |format|
      format.html { redirect_to(section_pieces_url) }
      format.xml  { head :ok }
    end
  end
end
