class ComplaintsController < ApplicationController
  before_filter :get_campus

  def get_campus
    @university = University.find(params[:university_id])
    @campus = @university.campuses.find(params[:campus_id])
  end

  # GET campuses/1/complaints
  # GET campuses/1/complaints.json
  def index
    authorize! :index, Complaint, :message => 'Acceso denegado.'
    @complaints = @campus.complaints.ordered

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @complaints }
    end
  end

  # GET campuses/1/complaints/1
  # GET campuses/1/complaints/1.json
  def show
    @complaint = @campus.complaints.find(params[:id])
    @complaints = @campus.complaints.ordered
    @comments = @complaint.comments.ordered
    authorize! :show, @complaint, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @complaint }
      format.js
    end
  end

  # GET campuses/1/complaints/new
  # GET campuses/1/complaints/new.json
  def new
    @complaint = @campus.complaints.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @complaint }
    end
  end

  # GET campuses/1/complaints/1/edit
  def edit
    @complaint = @campus.complaints.find(params[:id])
  end

  # POST campuses/1/complaints
  # POST campuses/1/complaints.json
  def create
    @campus = Campus.find(params[:campus_id])
    @complaint = @campus.complaints.build(params[:complaint])
    authorize! :create, @complaint, :message => 'Acceso denegado.'

    respond_to do |format|
      if @complaint.save
        format.html { redirect_to([@complaint.campus.university, @complaint.campus, @complaint], :notice => 'Complaint was successfully created.') }
        format.json { render :json => @complaint, :status => :created, :location => [@complaint.campus.university, @complaint.campus, @complaint] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @complaint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT campuses/1/complaints/1
  # PUT campuses/1/complaints/1.json
  def update
    @campus = Campus.find(params[:campus_id])
    @complaint = @campus.complaints.find(params[:id])
    authorize! :update, @complaint, :message => 'Acceso denegado.'

    respond_to do |format|
      if @complaint.update_attributes(params[:complaint])
        format.html { redirect_to([@complaint.campus.university, @complaint.campus, @complaint], :notice => 'Complaint was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @complaint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE campuses/1/complaints/1
  # DELETE campuses/1/complaints/1.json
  def destroy
    @complaint = @campus.complaints.find(params[:id])
    authorize! :destroy, @complaint, :message => 'Acceso denegado.'
    @complaint.destroy

    respond_to do |format|
      format.html { redirect_to university_campus_complaints_url(@university, @campus) }
      format.json { head :ok }
    end
  end
end
