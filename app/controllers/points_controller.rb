class PointsController < ApplicationController
  # GET /points
  # GET /points.json
  def index
    authorize! :index, @user, :message => 'No estas autorizado como administrador.'
    @search = Point.search(params[:q])
    @points = @search.result
    @search.build_condition

    respond_to do |format|
      format.html # index.html.erb
      format.json #{ render json: @points }
    end
  end

  # GET /points/1
  # GET /points/1.json
  def show
    authorize! :show, @user, :message => 'No estas autorizado como administrador.'
    @point = Point.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @point }
    end
  end

  # GET /points/new
  # GET /points/new.json
  def new
    authorize! :new, @user, :message => 'No estas autorizado como administrador.'
    @point = Point.new
    @types = Type.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @point }
    end
  end

  # GET /points/1/edit
  def edit
    authorize! :edit, @user, :message => 'No estas autorizado como administrador.'
    @point = Point.find(params[:id])
  end

  # POST /points
  # POST /points.json
  def create
    authorize! :create, @user, :message => 'No estas autorizado como administrador.'
    @point = Point.new(params[:point])
    @types = Type.all

    respond_to do |format|
      if @point.save
        format.html { redirect_to @point, notice: 'El punto fue creado exitosamente' }
        format.json { render json: @point, status: :created, location: @point }
      else
        format.html { render action: "new" }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /points/1
  # PUT /points/1.json
  def update
    authorize! :update, @user, :message => 'No estas autorizado como administrador.'
    @point = Point.find(params[:id])

    respond_to do |format|
      if @point.update_attributes(params[:point])
        format.html { redirect_to @point, notice: 'El punto fue editado exitosamente' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /points/1
  # DELETE /points/1.json
  def destroy
    authorize! :destroy, @user, :message => 'No estas autorizado como administrador.'
    @point = Point.find(params[:id])
    @point.destroy

    respond_to do |format|
      format.html { redirect_to points_url }
      format.json { head :no_content }
    end
  end
  
end
