#coding: utf-8
class ReportsController < ApplicationController
  
  before_filter :get_university
  before_filter :get_report, :only => [:show,:edit,:update,:destroy]

  def get_report
    @report = Report.find(params[:id])
  end

  def get_university
    @university=University.find(params[:university_id])
  end

  # GET /reports
  # GET /reports.json
  def index
    authorize! :index, Report, :message => 'Acceso denegado.'
    @campuses=@university.campuses
    @campuses2=@university.campuses
    @campuses_modificable = getcampuses_user(current_user)
    @reports=find_reports_from_university(@university)
    if params[:search]
      @search=params[:search]
      if @search
        @reports_search=(Report.where("name like ?","%#{@search.capitalize}%") | Report.where("name like ?","%#{@search.downcase}%") | Report.where("name like ?","%#{@search.upcase}%"))  
        @reports=@reports_search.select{|u| @reports.include?(u)}
        @searched=true
      end
    end
    if params[:campus]
      @search_campus=params[:campus]
      if @search_campus && params[:campus][:campus_id]
        @ids=params[:campus][:campus_id]
        if @ids!=""
          @campus_selected=Campus.find(params[:campus][:campus_id])
          @reports=@reports.select{|u| u.campuses.include?(@campus_selected)}
          @campuses2=@campuses.select{|u| u===@campus_selected}
        end
      end
    end
    @reports=@reports & @reports
    @reports.sort_by!{|u| u.name}
  end
 
  # GET /reports/1
  # GET /reports/1.json 
  def show
    @report = Report.find(params[:id])
    authorize! :show, @report, :message => 'Acceso denegado.'
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new
    @campuses = getcampuses_user(current_user)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
    authorize! :edit, @report, :message => 'Acceso denegado.'
    @campuses = getcampuses_user(current_user)
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])
    authorize! :create, @report, :message => 'Acceso denegado.'
    @campuses = getcampuses_user(current_user)
    respond_to do |format|
      if @report.save
        format.html { redirect_to [@university,@report], notice: 'La noticia fue creada con éxito' }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find(params[:id])
    authorize! :update, @report, :message => 'Acceso denegado.'
    @campuses = getcampuses_user(current_user)
    campusReport = Report.find(params[:report_id][:campus_ids]) rescue []
    @report.campuses=campusReport
    respond_to do |format|
      if @report.update_attributes(params[:report])
        format.html { redirect_to [@university,@report], notice: 'La noticia fue modificada exitosamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report = Report.find(params[:id])
    authorize! :destroy, @report, :message => 'Acceso denegado.'
    @report.destroy
    respond_to do |format|
      format.html { redirect_to university_reports_path(@university) }
      format.json { head :no_content }
    end
  end

  private

  #Se obtienen todas las noticias asociadas a una universidad
  def find_reports_from_university(university)
    reports=Report.all
    campuses=university.campuses
    filtred_reports=[]
    campuses.each do |campus|
      reports.each do |report|
        if report.campuses.include?(campus)
          filtred_reports<<report
          next 
        end
      end
    end
    return filtred_reports
  end
end
