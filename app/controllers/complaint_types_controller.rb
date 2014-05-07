class ComplaintTypesController < ApplicationController
  # GET universities/1/complaint_types
  # GET universities/1/complaint_types.json
  def index
    authorize! :index, ComplaintType, :message => 'Acceso denegado.'
    @university = University.find(params[:university_id])
    @complaint_types = @university.complaint_types.ordered

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @complaint_types }
    end
  end

  # GET universities/1/complaint_types/1
  # GET universities/1/complaint_types/1.json
  def show
    @university = University.find(params[:university_id])
    @complaint_type = @university.complaint_types.find(params[:id])
    authorize! :show, @complaint_type, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @complaint_type }
    end
  end

  # GET universities/1/complaint_types/new
  # GET universities/1/complaint_types/new.json
  def new
    @university = University.find(params[:university_id])
    @complaint_type = @university.complaint_types.build
    @modal_title = "Nuevo Tipo"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @complaint_type }
      format.js
    end
  end

  # GET universities/1/complaint_types/1/edit
  def edit
    @university = University.find(params[:university_id])
    @complaint_type = @university.complaint_types.find(params[:id])
    authorize! :edit, @complaint_type, :message => 'Acceso denegado.'
    @modal_title = "Editar Tipo"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @complaint_type }
      format.js
    end
  end

  # POST universities/1/complaint_types
  # POST universities/1/complaint_types.json
  def create
    @university = University.find(params[:university_id])
    @complaint_type = @university.complaint_types.build(params[:complaint_type])
    authorize! :create, @complaint_type, :message => 'Acceso denegado.'

    respond_to do |format|
      if @complaint_type.save
        format.html { redirect_to([@complaint_type.university, @complaint_type], :notice => 'El tipo de reclamo ha sido creado correctamente.') }
        format.json { render :json => @complaint_type, :status => :created, :location => [@complaint_type.university, @complaint_type] }
        format.js
      else
        format.html { render :action => "new" }
        format.json { render :json => @complaint_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT universities/1/complaint_types/1
  # PUT universities/1/complaint_types/1.json
  def update
    @university = University.find(params[:university_id])
    @complaint_type = @university.complaint_types.find(params[:id])
    authorize! :update, @complaint_type, :message => 'Acceso denegado.'

    respond_to do |format|
      if @complaint_type.update_attributes(params[:complaint_type])
        format.html { redirect_to([@complaint_type.university, @complaint_type], :notice => 'El tipo de reclamo ha sido actualizado correctamente.') }
        format.json { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.json { render :json => @complaint_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE universities/1/complaint_types/1
  # DELETE universities/1/complaint_types/1.json
  def destroy
    @university = University.find(params[:university_id])
    @complaint_type = @university.complaint_types.find(params[:id])
    authorize! :destroy, @complaint_type, :message => 'Acceso denegado.'
    @complaint_type.destroy

    respond_to do |format|
      format.html { redirect_to university_complaint_types_url(university) }
      format.json { head :ok }
      format.js
    end
  end
end
