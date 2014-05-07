class BuildingsController < ApplicationController
  before_filter :get_campus

  def get_campus
    @university = University.find(params[:university_id])
    @campus = @university.campuses.find(params[:campus_id])
  end
  
  # GET campuses/1/buildings
  # GET campuses/1/buildings.json
  def index
    authorize! :index, Building, :message => 'Acceso denegado.'
    @buildings = @campus.buildings
    @json_buildings = SmartCampusApi.generate_json_buildings(@buildings, false)
    respond_to do |format|
      format.json 	# index.json.erb
      format.js
    end
  end

  # GET campuses/1/buildings/1
  # GET campuses/1/buildings/1.json
  def show
    @building = @campus.buildings.find(params[:id])
    authorize! :show, @building, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @building }
      format.js
    end
  end

  # GET campuses/1/buildings/new
  # GET campuses/1/buildings/new.json
  def new
    @building = @campus.buildings.build
    @modal_title = "Nuevo Edificio"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @building }
      format.js
    end
  end

  # GET campuses/1/buildings/1/edit
  def edit
    @building = @campus.buildings.find(params[:id])
    authorize! :edit, @building, :message => 'Acceso denegado.'
    @modal_title = "Editar Edificio"

    respond_to do |format|
      format.js
    end
  end

  # POST campuses/1/buildings
  # POST campuses/1/buildings.json
  def create
		@buildings = @campus.buildings
    @building = @campus.buildings.build(params[:building])
    authorize! :create, @building, :message => 'Acceso denegado.'
    @modal_title = "Nuevo Edificio"

    respond_to do |format|
      if @building.save
        format.html { redirect_to([@building.campus.university,@building.campus, @building], :notice => t("activerecord.alerts.building.created")) }
        format.json { render :json => @building, :status => :created, :location => [@building.campus, @building] }
        format.js
      else
        format.html { render :action => "new" }
        format.json { render :json => @building.errors, :status => :unprocessable_entity }
        format.js		{ render :action => "new" }
      end
    end
  end

  # PUT campuses/1/buildings/1
  # PUT campuses/1/buildings/1.json
  def update
    @building = @campus.buildings.find(params[:id])
    authorize! :update, @building, :message => 'Acceso denegado.'
    @modal_title = "Editar Edificio"

    respond_to do |format|
      if @building.update_attributes(params[:building])
        format.html { redirect_to([@building.campus.university, @building.campus, @building], :notice => t("activerecord.alerts.building.updated")) }
        format.json { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.json { render :json => @building.errors, :status => :unprocessable_entity }
        format.js		{ render :action => "edit" }
      end
    end
  end

  # DELETE campuses/1/buildings/1
  # DELETE campuses/1/buildings/1.json
  def destroy
		@buildings = @campus.buildings
    @building = @campus.buildings.find(params[:id])
    authorize! :destroy, @building, :message => 'Acceso denegado.'
    @building.destroy

    respond_to do |format|
      format.html { redirect_to university_campus_buildings_url(@campus.university, @campus) }
      format.json { head :ok }
      format.js
    end
  end
end
