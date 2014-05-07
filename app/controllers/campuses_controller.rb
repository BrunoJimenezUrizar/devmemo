#coding: utf-8
class CampusesController < ApplicationController

  before_filter :get_university

  def get_university
    @university = University.find(params[:university_id])
  end
  # GET /campuses
  # GET /campuses.json

  
  def index
    authorize! :index, Campus, :message => 'Acceso denegado.'
    @campuses = @university.campuses

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campuses }
    end
  end

  # GET /campuses/1
  # GET /campuses/1.json
  def show
    @campus = @university.campuses.includes(:pors).find(params[:id])
    authorize! :show, @campus, :message => 'Acceso denegado.'
    @buildings = @campus.buildings.order(:name)#.paginate(:per_page => 3, :page => params[:buildings_page])
    @pors = @campus.pors.order(:name)#.paginate(:per_page => 3, :page => params[:pors_page])
    @pois = @campus.pois.order(:name)#.paginate(:per_page => 3, :page => params[:pois_page])
    @events= @campus.events.order(:name)
    #se declaran las opciones para la seleccion de búsqueda
    @options = [['Edificio', 0], ['Punto de interés', 1], ['Punto de reciclaje', 2], 
['Evento', 3]]
    @object_filtered=[]  
    if params[:search]
      search=params[:search]
      @class_search=params[:option][:option_id]
      if @class_search==='0'
        @object_filtered=get_items('Building',search,params[:id])
      elsif @class_search=='2'
        @object_filtered=get_items('Por',search,params[:id])
      elsif @class_search=='1'
        @object_filtered=get_items('Poi',search,params[:id])
      elsif @class_search=='3'
        @object_filtered=get_items('Event',search,params[:id])
      end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @campus }
      format.js
    end
  end

  # GET /campuses/new
  # GET /campuses/new.json
  def new
    @campus = Campus.new
    @modal_title = "Nuevo Campus"
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @campus }
      format.js
    end
  end

  # GET /campuses/1/edit
  def edit
    @campus = @university.campuses.find(params[:id])
    authorize! :edit, @campus, :message => 'Acceso denegado.'
    @modal_title = "Editar Campus"
    
  end

  # POST /campuses
  # POST /campuses.json
  def create
    @campus = @university.campuses.new(params[:campus])
    authorize! :create, @campus, :message => 'Acceso denegado.'
    @modal_title = "Nuevo Campus"

    respond_to do |format|
      if @campus.save
        format.html { redirect_to [@university, @campus], notice: t("activerecord.alerts.campus.created") }
        format.json { render json: [@university, @campus], status: :created, location: [@university, @campus] }
				format.js
      else
        format.html { render action: "new" }
        format.json { render json: @campus.errors, status: :unprocessable_entity }
				format.js		{ render action: "new" }
      end
    end
  end

  # PUT /campuses/1
  # PUT /campuses/1.json
  def update
    @campus = @university.campuses.find(params[:id])
    authorize! :update, @campus, :message => 'Acceso denegado.'
    @modal_title = "Editar Campus"

    respond_to do |format|
      if @campus.update_attributes(params[:campus])
        format.html { redirect_to [@university, @campus], notice: t("activerecord.alerts.campus.updated") }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @campus.errors, status: :unprocessable_entity }
				format.js		{ render action: "edit" }
      end
    end
  end

  # DELETE /campuses/1
  # DELETE /campuses/1.json
  def destroy
    @campus = @university.campuses.find(params[:id])
    authorize! :destroy, @campus, :message => 'Acceso denegado.'
    @campus.destroy

    respond_to do |format|
      format.html { redirect_to universities_path }
      format.json { head :no_content }
      format.js
    end
  end

  private

  def get_items(class_search_string,search,campus_id)
    class_search=Object.const_get class_search_string
    print class_search
    objects=(class_search.where("name like ?","%#{search.capitalize}%") | class_search.where("name like ?","%#{search.downcase}%") | class_search.where("name like ?","%#{search.upcase}%"))  
    objects=objects.select{|x| x.campus_id==campus_id.to_i}
    return objects  
  end
end
