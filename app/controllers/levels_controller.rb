class LevelsController < ApplicationController
  # GET /levels
  # GET /levels.json
  def index
    @levels = Level.order("points DESC").all
    authorize! :index, @floor, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @levels }
    end
  end

  # GET /levels/1
  # GET /levels/1.json
  def show
    @level = Level.find(params[:id])
    authorize! :show, @level, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @level }
    end
  end

  # GET /levels/new
  # GET /levels/new.json
  def new
    @level = Level.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @level }
    end
  end

  # GET /levels/1/edit
  def edit
    @level = Level.find(params[:id])
    authorize! :edit, @level, :message => 'Acceso denegado.'
  end

  # POST /levels
  # POST /levels.json
  def create
    @level = Level.new(params[:level])
    authorize! :create, @level, :message => 'Acceso denegado.'

    respond_to do |format|
      if @level.save
        format.html { redirect_to @level, notice: t("activerecord.alerts.level.created") }
        format.json { render json: @level, status: :created, location: @level }
      else
        format.html { render action: "new" }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /levels/1
  # PUT /levels/1.json
  def update
    @level = Level.find(params[:id])
    authorize! :update, @level, :message => 'Acceso denegado.'

    respond_to do |format|
      if @level.update_attributes(params[:level])
        format.html { redirect_to @level, notice: t("activerecord.alerts.level.updated") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /levels/1
  # DELETE /levels/1.json
  def destroy
    @level = Level.find(params[:id])
    authorize! :destroy, @level, :message => 'Acceso denegado.'
    @level.destroy

    respond_to do |format|
      format.html { redirect_to levels_url }
      format.json { head :no_content }
    end
  end
end
