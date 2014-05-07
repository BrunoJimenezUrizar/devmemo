class UniversitiesController < ApplicationController

  # GET /universities
  # GET /universities.json
  def index
    authorize! :index, University, :message => 'Acceso denegado.'
    @universities = University.all
    @universities.sort_by!{|u| u.name}
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /universities/1
  # GET /universities/1.json
  def show
    @university = University.find(params[:id])
    authorize! :show, @university, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @university }
    end
  end

  # GET /universities/new
  # GET /universities/new.json
  def new
    @university = University.new
    @modal_title = "Nueva Universidad"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @university }
      format.js #new.js.erb
    end
  end

  # GET /universities/1/edit
  def edit
    @university = University.find(params[:id])
    authorize! :edit, @university, :message => 'Acceso denegado.'
    @modal_title = "Editar Universidad"
    @action="edit"
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.js #new.js.erb
    #end
  end

  # POST /universities
  # POST /universities.json
  def create
    @university = University.new(params[:university])
    authorize! :create, @university, :message => 'Acceso denegado.'

    respond_to do |format|
      if @university.save
        format.html { redirect_to universities_path, notice: 'La universidad fue creada con exito.' }
        format.json { render json: @university, status: :created, location: @university }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @university.errors, status: :unprocessable_entity }
        format.js { render action: "new" }
      end
    end
  end

  # PUT /universities/1
  # PUT /universities/1.json
  def update
    @university = University.find(params[:id])
    authorize! :update, @university, :message => 'Acceso denegado.'

    respond_to do |format|
      if @university.update_attributes(params[:university])
        format.html { redirect_to universities_url, notice: 'La universidad fue modificada exitosamenete.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @university.errors, status: :unprocessable_entity }
        format.js { render action: "edit" }
      end
    end
  end

  # DELETE /universities/1
  # DELETE /universities/1.json
  def destroy
    @university = University.find(params[:id])
    authorize! :destroy, @university, :message => 'Acceso denegado.'
    @university.destroy

    respond_to do |format|
      format.html { redirect_to universities_url }
      format.json { head :no_content }
      format.js
    end
  end
end
