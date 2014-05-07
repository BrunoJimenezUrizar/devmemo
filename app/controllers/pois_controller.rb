#coding: utf-8
class PoisController < ApplicationController
  before_filter :get_campus

  def get_campus
    @university = University.find(params[:university_id])
    @campus = @university.campuses.find(params[:campus_id])
  end
  # GET campuses/1/pois
  # GET campuses/1/pois.json
  def index
    #@search = @campus.pois.search(params[:q])
    #@pois = @search.result
    authorize! :index, Poi, :message => 'Acceso denegado.'
    @pois = @campus.pois
    @points = @pois
    @point_name = "poi"
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render "points/index.json.erb" } # index.json.erb
    end
  end

  # GET campuses/1/pois/1
  # GET campuses/1/pois/1.json
  def show
    @poi = @campus.pois.find(params[:id])
    authorize! :show, @poi, :message => 'Acceso denegado.'
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @poi }
    end
  end

  # GET campuses/1/pois/new
  # GET campuses/1/pois/new.json
  def new
    @poi = @campus.pois.build
   
    @action="new"
    @modal_title = "Nuevo Punto de Interes"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @poi }
      format.js
    end
  end

  # GET campuses/1/pois/1/edit
  def edit
    @poi = @campus.pois.find(params[:id])
    authorize! :edit, @poi, :message => 'Acceso denegado.'
    
    
    @action="edit"
    @modal_title = "Editar Punto de Interes"

    respond_to do |format|
      format.js
    end
  end

  # POST campuses/1/pois
  # POST campuses/1/pois.json
  def create
  	@pois = @campus.pois
    @poi = @campus.pois.build(params[:poi])
    authorize! :create, @poi, :message => 'Acceso denegado.'
    @modal_title = "Nuevo Punto de Interes"

    respond_to do |format|
      if @poi.save
        format.html { redirect_to([@university, @poi.campus, @poi], :notice => 'El Punto de interés fue creado con éxito') }
        format.json { render :json => @poi, :status => :created, :location => [@university, @poi.campus, @poi] }
        format.js
      else
        format.html { render :action => "new" }
        format.json { render :json => @poi.errors, :status => :unprocessable_entity }
        format.js		{ render :action => "new"}
      end
    end
  end

  # PUT campuses/1/pois/1
  # PUT campuses/1/pois/1.json
  def update
    @poi = @campus.pois.find(params[:id])
    authorize! :update, @poi, :message => 'Acceso denegado.'
    @modal_title = "Editar Punto de Interes"

    respond_to do |format|
      if @poi.update_attributes(params[:poi])
        format.html { redirect_to([@university, @poi.campus, @poi], :notice => 'El punto de interés fue modificado exitoosamente') }
        format.json { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.json { render :json => @poi.errors, :status => :unprocessable_entity }
        format.js		{ render :action => "edit" }
      end
    end
  end

  # DELETE campuses/1/pois/1
  # DELETE campuses/1/pois/1.json
  def destroy
  	@pois = @campus.pois
    @poi = @campus.pois.find(params[:id])
    authorize! :destroy, @poi, :message => 'Acceso denegado.'
    @poi.destroy

    respond_to do |format|
      format.html { redirect_to university_campus_pois_url(@university, @campus) }
      format.json { head :ok }
      format.js
    end
  end
end
