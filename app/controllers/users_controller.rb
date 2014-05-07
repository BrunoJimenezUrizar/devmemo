#coding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.order('name ASC')
  end

  def update
    @user = current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        sign_in(current_user, :bypass => true)
        format.html { redirect_to session.delete(:return_to), notice: 'Su cuenta ha sido actualizada con éxito.' }
        format.json { head :no_content }
      else
        action=Rails.application.routes.recognize_path(request.referer)[:action] 
        if action==="edit_current_user"
          format.html { render :edit }
        else
          format.html { render "edit_password"}
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  	@user = User.find(params[:id])
  end

  def destroy
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "Usuario borrado."
    else
      redirect_to users_path, :notice => "No puedes borrarte a ti mismo."
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'El usuario fue creado con éxito.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def edit_password_current_user
    @user=current_user
    session[:return_to] ||= request.referer
    render :edit_password
  end

  # ¿Borrar esto?
  def edit_roles_user
    @user = User.find(params[:id])
  end

  def edit_current_user
    @user=current_user
    session[:return_to] ||= request.referer
    render :edit
  end


  # ¿Borrar esto?
  def update_roles_user
    @user=User.find(params[:id])
    rolesUser = Role.find_all_by_id(params[:user][:role_ids]) rescue []
    if rolesUser
      @user.roles=rolesUser
    end
    respond_to do |format|
      if @user.roles == rolesUser
        format.html { redirect_to users_path, notice: 'El usuario ha sido actualizado' }
        format.json { head :no_content }
      else
        format.html { redirect_to users_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # ¿Borrar esto?
  def update_campuses_user
    @user=User.find(params[:id])
    campusesUser = Campus.find_all_by_id(params[:user][:campus_ids]) rescue []
    if campusesUser
      @user.campuses=campusesUser
    end
    respond_to do |format|
      if @user.campuses == campusesUser
        format.html { redirect_to users_path, notice: 'El usuario ha sido actualizado' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # ¿Borrar esto?
  def update_current_user
    @user = current_user
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "El usuario ha sido actualizado"
    else
      redirect_to users_path, :alert => "No es posible actualizar al usuario actual."
    end
  end

  def university_admin
    if current_user.has_role? :super_admin
      @university = University.find(params[:university_id])
      respond_to do |format|
        format.html # new.html.erb
        format.js
      end
    else
      redirect_to root_url
    end
  end

  def university_admin_create
    if current_user.has_role? :super_admin
      @user = User.find(params[:user])
      @university = University.find(params[:university_id])
      @user.add_role :university_admin, @university

      redirect_to university_admin_users_path(@university.id, :university_id => @university.id)
    else
      redirect_to root_url
    end
  end

  def university_admin_remove
    if current_user.has_role? :super_admin
      @user = User.find(params[:user_id])
      @university = University.find(params[:university_id])
      @user.remove_role :university_admin, @university

      redirect_to university_admin_users_path(@university.id, :university_id => @university.id)
    else
      redirect_to root_url
    end
  end

  def campus_admin
    @campus = Campus.find(params[:campus_id])
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def campus_admin_create
    @campus = Campus.find(params[:campus_id])
    if current_user.has_role? :super_admin or University.with_role(:university_admin, current_user).map(&:id).include?(@campus.university.id) or Campus.with_role(:campus_admin, current_user).map(&:id).include?(@campus.id)
      @user = User.find(params[:user])
      if params[:admin] == "1"
        @user.add_role :campus_admin, @campus
      else
        @user.add_role :admin, @campus
      end
      redirect_to campus_admin_users_path(@campus.id, :campus_id => @campus.id)
    else
      redirect_to root_url
    end
  end

  def campus_admin_remove
    @campus = Campus.find(params[:campus_id])
    if current_user.has_role? :super_admin or University.with_role(:university_admin, current_user).map(&:id).include?(@campus.university.id) or Campus.with_role(:campus_admin, current_user).map(&:id).include?(@campus.id)
      @user = User.find(params[:user_id])
      if params[:admin] == "1"
        @user.remove_role :campus_admin, @campus
      else
        @user.remove_role :admin, @campus
      end
      redirect_to campus_admin_users_path(@campus.id, :campus_id => @campus.id)
    else
      redirect_to root_url
    end
  end

end

