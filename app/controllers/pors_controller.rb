#coding: utf-8
class PorsController < ApplicationController
  before_filter :get_campus
  
  def get_campus
    @university = University.find(params[:university_id])
    @campus = @university.campuses.find(params[:campus_id])
  end
   
  # GET campuses/1/pors
  # GET campuses/1/pors.json
  def index
    authorize! :index, Por, :message => 'Acceso denegado.'
    @pors = @campus.pors.paginate(:per_page => 3, :page => params[:page])
		@points = @pors
		@point_name = "por"

    respond_to do |format|
      format.html # index.html.erb
      format.json { render "points/index.json.erb" } # index.json.erb
    end
  end

  # GET campuses/1/pors/1
  # GET campuses/1/pors/1.json
  def show
    @por = @campus.pors.find(params[:id])
    authorize! :show, @por, :message => 'Acceso denegado.'
   

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @por }
    end
  end

  # GET campuses/1/pors/new
  # GET campuses/1/pors/new.json
  def new
    @por = @campus.pors.build
    @action="new"
    @modal_title = "Nuevo Punto de Reciclaje"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @por }
      format.js
    end
  end

  # GET campuses/1/pors/1/edit
  def edit
    @por = @campus.pors.find(params[:id])
    authorize! :edit, @por, :message => 'Acceso denegado.'
    @action="edit"
    @modal_title = "Editar Punto de Reciclaje"

    respond_to do |format|
      format.js
    end
  end

  # POST campuses/1/pors
  # POST campuses/1/pors.json
  def create
	  @pors = @campus.pors
    @por = Por.new(params[:por])
    authorize! :create, @por, :message => 'Acceso denegado.'
	  @por.campus = @campus
    @modal_title = "Nuevo Punto de Reciclaje"
		
    respond_to do |format|
      if @por.save
        format.html { redirect_to([@university, @campus], :notice => 'El punto de reciclaje fue creado con éxito') }
        format.json { render :json => @por, :status => :created, :location => [@university, @campus, @por] }
        format.js
      else
        format.html { render :action => "new" }
        format.json { render :json => @por.errors, :status => :unprocessable_entity }
        format.js		{ render :action => "new"}
      end
    end
  end

  # PUT campuses/1/pors/1
  # PUT campuses/1/pors/1.json
  def update
    @por = @campus.pors.find(params[:id])
    authorize! :update, @por, :message => 'Acceso denegado.'
    @modal_title = "Editar Punto de Reciclaje"

    respond_to do |format|
      if @por.update_attributes(params[:por])
        format.html { redirect_to([@university, @campus], :notice => 'El punto de reciclaje fue modificado exitosamente') }
        format.json { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.json { render :json => @por.errors, :status => :unprocessable_entity }
				format.js		{ render :action => "edit" }
      end
    end
  end

  # DELETE campuses/1/pors/1
  # DELETE campuses/1/pors/1.json
  def destroy
	  @pors = @campus.pors
    @por = @campus.pors.find(params[:id])
    authorize! :destroy, @por, :message => 'Acceso denegado.'
    @por.destroy

    respond_to do |format|
      format.html { redirect_to university_campus_pors_url(@university, @campus) }
      format.json { head :ok }
      format.js
    end
  end
end
