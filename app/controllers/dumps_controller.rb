class DumpsController < ApplicationController
  # GET /dumps
  # GET /dumps.json
  def index
    authorize! :index, Dump, :message => 'Acceso denegado.'
    @dumps = Dump.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dumps }
    end
  end

  # GET /dumps/1
  # GET /dumps/1.json
  def show
    @dump = Dump.find(params[:id])
    authorize! :show, @dump, :message => 'Acceso denegado.'
    @id = params[:id]
    @por = Por.find(@dump.por_id)
    @url = "https://chart.googleapis.com/chart?cht=qr&chs=250x250&chl=R-"+@dump.id.to_s

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dump }
      format.js
    end
  end

  # GET /dumps/new
  # GET /dumps/new.json
  def new
    @dump = Dump.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dump }
    end
  end

  # GET /dumps/1/edit
  def edit
    authorize! :edit, @dump, :message => 'Acceso denegado.'
    @dump = Dump.find(params[:id])
  end

  # POST /dumps
  # POST /dumps.json
  def create
    @dump = Dump.new(params[:dump])
    authorize! :create, @dump, :message => 'Acceso denegado.'

    respond_to do |format|
      if @dump.save
        format.html { redirect_to @dump, notice: 'El basurero fue creado exitosamente.' }
        format.json { render json: @dump, status: :created, location: @dump }
      else
        format.html { render action: "new" }
        format.json { render json: @dump.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dumps/1
  # PUT /dumps/1.json
  def update
    @dump = Dump.find(params[:id])
    authorize! :update, @dump, :message => 'Acceso denegado.'

    respond_to do |format|
      if @dump.update_attributes(params[:dump])
        format.html { redirect_to @dump, notice: 'El basurero fue modificado exitosamente' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dump.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dumps/1
  # DELETE /dumps/1.json
  def destroy
    @dump = Dump.find(params[:id])
    authorize! :destroy, @dump, :message => 'Acceso denegado.'
    @dump.destroy

    respond_to do |format|
      format.html { redirect_to dumps_url }
      format.json { head :no_content }
    end
  end

  #Metodo para descargar una imagen con el codigo QR asociado al basurero.
  def download
    @dump= Dump.find(params[:dump_id])
    authorize! :download, @dump, :message => 'Acceso denegado.'
    @por = Por.find(@dump.por_id)
    @campus = Campus.find(@por.campus_id)
    @university = University.find(@campus.university_id)

    require 'open-uri'
    @file
    width = params[:width]
    height = params[:height]
    size = width+"x"+height
    @url = "https://chart.googleapis.com/chart?cht=qr&chs="+size+"&chl=R-"+@dump.id.to_s
    
    #Creamos la imagen a partir de la API y las especificaciones del usuario
    open('image.png', 'wb') do |file|
      encoded_url = URI.encode(@url)
      file << open(URI.parse(encoded_url)).read
      @file = file
    end
    
    name = @university.acronym+"_"+@campus.name+"_"+@por.name+"_"+@dump.type.name+"_QR_"+size
    name.to_s
    
    #Abrimos el archivo para enviarlo por send_data
    File.open(@file.path, 'r') do |f|
      send_data f.read, type: "image/png", :filename => name
    end
    #Eliminamos el archivo recien creado para no llenar el servidor
    File.delete(@file.path) if File.exist?(@file.path)
  end

end
