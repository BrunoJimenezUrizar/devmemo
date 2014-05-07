class TypesController < ApplicationController
before_filter :get_university

  def get_university
    @university = University.find(params[:university_id])
  end
  # GET /types
  # GET /types.json
  def index
    authorize! :index, Type, :message => 'Acceso denegado.'
    @types = @university.types

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @types }
      format.js
    end
  end

  # GET /types/1
  # GET /types/1.json
  def show
    @type = @university.types.find(params[:id])
    authorize! :show, @type, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @type }
      format.js
    end
  end

  # GET /types/new
  # GET /types/new.json
  def new
    @type = Type.new
    @modal_title = "Nuevo Tipo de Punto de Reciclaje"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @type }
      format.js
    end
  end

  # GET /types/1/edit
  def edit
    @type = @university.types.find(params[:id])
    authorize! :edit, @type, :message => 'Acceso denegado.'
    @modal_title = "Editar Tipo de Punto de Reciclaje"
    
    respond_to do |format|
      format.js
    end
  end

  # POST /types
  # POST /types.json
  def create
    @type = @university.types.new(params[:type])
    authorize! :create, @type, :message => 'Acceso denegado.'

    respond_to do |format|
      if @type.save
        format.html { redirect_to university_types_path(@university), notice: 'Tipo creado exitosamente' }
        format.json { render json: @type, status: :created, location: @type }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /types/1
  # PUT /types/1.json
  def update
    @type = @university.types.find(params[:id])
    authorize! :update, @type, :message => 'Acceso denegado.'

    respond_to do |format|
      if @type.update_attributes(params[:type])
        format.html { redirect_to university_types_path(@university), notice: 'Tipo fue editado exitosamente' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /types/1
  # DELETE /types/1.json
  def destroy
    @type = @university.types.find(params[:id])
    authorize! :destroy, @type, :message => 'Acceso denegado.'
    @type.destroy

    respond_to do |format|
      format.html { redirect_to university_types_path(@university) }
      format.json { head :no_content }
      format.js
    end
  end
end
