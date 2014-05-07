#coding: utf-8
class EventsController < ApplicationController
  
  before_filter :get_campus, :except => [:download]

  def get_campus
    @university = University.find(params[:university_id])
    @campus = @university.campuses.find(params[:campus_id])
  end
  # GET /events
  # GET /events.json
  def index
    authorize! :index, Event, :message => 'Acceso denegado.'
    @events = @campus.events
    @points = @events
    @point_name = "event"
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render "points/index.json.erb" } # index.json.erb
      format.js
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = @campus.events.find(params[:id])
    authorize! :show, @event, :message => 'Acceso denegado.'
    @university = @event.campus.university
    @campus = @event.campus
    @url = "https://chart.googleapis.com/chart?cht=qr&chs=200x200"+"&chl=E-"+@event.id.to_s

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
      format.js
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = @campus.events.build
    @action ="new"
    @modal_title = "Nuevo Evento"
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
      format.js
    end
  end

  # GET /events/1/edit
  def edit
    @event = @campus.events.find(params[:id])
    authorize! :edit, @event, :message => 'Acceso denegado.'
    @action ="edit"
    @modal_title = "Editar Evento"
  end

  # POST /events
  # POST /events.json
  def create
  	@events = @campus.events
    @event = @campus.events.build(params[:event])
    authorize! :create, @event, :message => 'Acceso denegado.'
    @modal_title = "Nuevo Evento"

    respond_to do |format|
      if @event.save
        format.html { redirect_to [@university, @event.campus], notice: 'El evento fue creado exitosamente' }
        format.json { render json: @event, status: :created, location: [@university, @event.campus, @event]}
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
        format.js		{ render :action => "new"}
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = @campus.events.find(params[:id])
    authorize! :update, @event, :message => 'Acceso denegado.'
    @modal_title = "Editar Evento"

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to [@university, @event.campus], notice: 'El evento fue modificado con éxito' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
        format.js		{ render :action => "edit" }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
  	@events = @campus.events
    @event = @campus.events.find(params[:id])
    authorize! :destroy, @event, :message => 'Acceso denegado.'
    @event.destroy

    respond_to do |format|
      format.html { redirect_to university_campus_events_url(@university, @campus) }
      format.json { head :no_content }
      format.js
    end
  end

  def download
    @event = Event.find(params[:event_id])
    authorize! :download, @event, :message => 'Acceso denegado.'
    university = @event.campus.university
    campus = @event.campus
    date = @event.start_date

    require 'open-uri'
    @file
    width = params[:width]
    height = params[:height]
    size = width+"x"+height
    @url = "https://chart.googleapis.com/chart?cht=qr&chs="+size+"&chl="+"E-"+@event.id.to_s
    
    #Creamos la imagen a partir de la API y las especificaciones del usuario
    open('image.png', 'wb') do |file|
      encoded_url = URI.encode(@url)
      file << open(URI.parse(encoded_url)).read
      @file = file
    end
    
    name = university.name+"_"+campus.name+"_"+date.strftime("%d-%m-%y")+"_"+@event.name+"_QR_"+size
    name.to_s
    
    #Abrimos el archivo para enviarlo por send_data
    File.open(@file.path, 'r') do |f|
      send_data f.read, type: "image/png", :filename => name
    end
    #Eliminamos el archivo recien creado para no llenar el servidor
    File.delete(@file.path) if File.exist?(@file.path)
    #-----------------------------
    #send_data @file.path, :filename => name, :type => 'image/png'
    #FileUtils.rm @file.path
    #-----------------------------
  end

end
