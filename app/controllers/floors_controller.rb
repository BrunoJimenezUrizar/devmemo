#coding: utf-8
class FloorsController < ApplicationController
  before_filter :get_building
  def get_building
    @university = University.find(params[:university_id])
    @campus = @university.campuses.find(params[:campus_id])
    @building = @campus.buildings.find(params[:building_id])
  end

  # GET buildings/1/floors
  # GET buildings/1/floors.json
  def index
    authorize! :index, Floor, :message => 'Acceso denegado.'
    @floors = @building.floors

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @floors }
    end
  end

  # GET buildings/1/floors/1
  # GET buildings/1/floors/1.json
  def show
    @floor = @building.floors.find(params[:id])
    authorize! :show, @floor, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @floor }
      format.js
    end
  end

  # GET buildings/1/floors/new
  # GET buildings/1/floors/new.json
  def new
    @floor = @building.floors.build
    @modal_title = "Nuevo Piso"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @floor }
      format.js
    end
  end

  # GET buildings/1/floors/1/edit
  def edit
    @floor = @building.floors.find(params[:id])
    authorize! :edit, @floor, :message => 'Acceso denegado.'
    @modal_title = "Editar Piso"

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # POST buildings/1/floors
  # POST buildings/1/floors.json
  def create
    @building = Building.find(params[:building_id])
    @floor = @building.floors.build(params[:floor])
    authorize! :create, @floor, :message => 'Acceso denegado.'

    respond_to do |format|
      if @floor.save
        format.html { redirect_to([@university, @campus], :notice => 'El piso fue creaco con éxito') }
        format.json { render :json => @floor, :status => :created, :location => [@university, @campus, @building, @floor] }
        format.js
      else
        format.html { render :action => "new" }
        format.json { render :json => @floor.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT buildings/1/floors/1
  # PUT buildings/1/floors/1.json
  def update
    @building = Building.find(params[:building_id])
    @floor = @building.floors.find(params[:id])
    authorize! :update, @floor, :message => 'Acceso denegado.'

    respond_to do |format|
      if @floor.update_attributes(params[:floor])
        format.html { redirect_to([@university, @campus, @building, @floor], :notice => 'El piso fue modificado con éxito') }
        format.json { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.json { render :json => @floor.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE buildings/1/floors/1
  # DELETE buildings/1/floors/1.json
  def destroy
    @building = Building.find(params[:building_id])
    @floor = @building.floors.find(params[:id])
    authorize! :destroy, @floor, :message => 'Acceso denegado.'
    @floor.destroy

    respond_to do |format|
      format.html { redirect_to building_floors_url(building) }
      format.json { head :ok }
      format.js
    end
  end
end
