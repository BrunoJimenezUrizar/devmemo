#coding: utf-8
  class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end


  def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
  end

  def getcampuses_user(user)
    if user.has_role? :super_admin
      return Campus.all
    else
      return user.campuses
    end
  end


  def can_administer? # Metodo que define quienes pueden administrar las encuestas
    university = @university = University.find(params[:university_id])
    if current_user.has_role? :super_admin or University.with_role(:university_admin, current_user).map(&:id).include?(university.id) or Campus.with_role(:campus_admin, current_user).map(&:university_id).include?(university.id) or Campus.with_role(:admin, current_user).map(&:university_id).include?(university.id)
      return true
    else
      return false
    end
  end


  def remember_location
    session[:back_paths] ||= []
    unless session[:back_paths].last == request.fullpath
      session[:back_paths] << request.fullpath
    end

    session[:back_paths] = session[:back_paths][-10..-1]
  end

  def back
    session[:back_paths] ||= []
    session[:back_paths].pop || :back
  end
end
