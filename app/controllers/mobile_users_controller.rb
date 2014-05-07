#!/bin/env ruby
#coding: utf-8
class MobileUsersController < ApplicationController

  # GET /mobile_users
  # GET /mobile_users.json
  def index
    authorize! :index, MobileUser, :message => 'Acceso denegado.'
    @mobile_users = MobileUser.all
    @types=Type.where(university_id:params[:university])
    @universities= []
    University.all.each do |university|
      if current_user.has_role? :super_admin or University.with_role(:university_admin, current_user).map(&:id).include?(university.id) or Campus.with_role(:campus_admin, current_user).map(&:university_id).include?(university.id)
        @universities << university
      end
    end
    @from= params[:from]
    @to= params[:to]
    @university= params[:university]


  # Creacion de tabla para grafico de usuarios registrados los ultimos 6 meses
  data_table = GoogleVisualr::DataTable.new
  data_table.new_column('string', 'Mes' )
  data_table.new_column('number', 'Usuarios registrados')
  data_table.add_rows([
    [I18n.l(6.month.ago, :format=>"%B"), MobileUser.where(created_at: 6.month.ago.beginning_of_month..6.month.ago.end_of_month).count ],
    [I18n.l(5.month.ago, :format=>"%B"), MobileUser.where(created_at: 5.month.ago.beginning_of_month..5.month.ago.end_of_month).count ],
    [I18n.l(4.month.ago, :format=>"%B"), MobileUser.where(created_at: 4.month.ago.beginning_of_month..4.month.ago.end_of_month).count ],
    [I18n.l(3.month.ago, :format=>"%B"), MobileUser.where(created_at: 3.month.ago.beginning_of_month..3.month.ago.end_of_month).count ],
    [I18n.l(2.month.ago, :format=>"%B"), MobileUser.where(created_at: 2.month.ago.beginning_of_month..2.month.ago.end_of_month).count ],
    [I18n.l(1.month.ago, :format=>"%B"), MobileUser.where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).count ]])
  
  option = { height: 150, title: 'Usuarios registrados de los ultimos 6 meses', legend:'none'}
  @chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, option)

  #usuarios registrados en el mes actual
  @this_month_users= MobileUser.where(created_at: Time.now.beginning_of_month..Time.now.end_of_day).count 
  #usuarios registrados en la semana actual
  @this_week_users= MobileUser.where(created_at: Time.now.beginning_of_week..Time.now.end_of_day).count 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mobile_users }

    end
  end

  # GET /mobile_users/1
  # GET /mobile_users/1.json
  def show
    @mobile_user = MobileUser.find(params[:id])
    authorize! :show, @mobile_user, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mobile_user }
    end
  end

  # GET /mobile_users/new
  # GET /mobile_users/new.json
  def new
    @mobile_user = MobileUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mobile_user }
    end
  end

  # GET /mobile_users/1/edit
  def edit
    @mobile_user = MobileUser.find(params[:id])
  end

  # POST /mobile_users
  # POST /mobile_users.json
  def create(profile,graph)
    @mobile_user = MobileUser.new
   
    #set data in the object
    @mobile_user.email = profile["email"]
    @mobile_user.name = profile["first_name"]
    @mobile_user.last_name = profile["last_name"]
    @mobile_user.nickname = profile["username"]
    @mobile_user.fb_id = profile["id"]
    @mobile_user.profile_picture_url = graph.get_picture(profile["id"])
    @mobile_user.link = profile["link"]
    @mobile_user.birthday = profile["birthday"]
    @mobile_user.gender = profile["gender"]
    @mobile_user.access_token= params[:access_token]
    
    respond_to do |format|
      if profile and @mobile_user.save
        format.json { render json: @mobile_user.api_token, status: :created, location: @mobile_user.api_token, :message=> "Inicio de sesión exitosa" }

      else
        format.json { render json: @mobile_user.errors, status: :unprocessable_entity }
      end
    end

  end

  # PUT /mobile_users/1
  # PUT /mobile_users/1.json
  def update
    @mobile_user = MobileUser.find(params[:id])

    respond_to do |format|
      if @mobile_user.update_attributes(params[:mobile_user])
        format.html { redirect_to @mobile_user, notice: 'El usuario móvil ha sido modificado con éxito' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mobile_user.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /mobile_users/1
  # DELETE /mobile_users/1.json
  def destroy
    @mobile_user = MobileUser.find(params[:id])
    @mobile_user.destroy

    respond_to do |format|
      format.html { redirect_to mobile_users_url }
      format.json { head :no_content }
    end
  end

  

  def login 
    api_token = params[:api_token]
    access_token = params[:access_token]
    mobile_user = MobileUser.find_by_api_token(api_token)
    
    #Si se encuentra al usuario movil
    if mobile_user
      render :json => { :message =>"¡Inicio de sesión exitosa!", :authenticated => true }.to_json    
    #Si se envio el access_token
    elsif access_token
      begin
      graph = Koala::Facebook::API.new(params[:access_token])
      profile = graph.get_object('me')
      rescue Koala::Facebook::AuthenticationError => e
      end
      #Si es válido el access_token este objeto existirá
      if profile
        mobile_user = MobileUser.find_by_fb_id(profile['id'])
        if mobile_user
          render :json => {:api_token => mobile_user.api_token, :authenticated => true}.to_json
        else
          create(profile, graph)
        end
      else
        render :json => { :message => "access_token inválida" }.to_json
      end
    #No se envió ni el access_token ni api_token correcto
    else
      render :json => { :message => "Error no se envió ni api_token ni access_token o fueron incorrectos" }.to_json
    end
  end

end
