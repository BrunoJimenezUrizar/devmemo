class CommentsController < ApplicationController
  before_filter :get_complaint

  def get_complaint
    @university = University.find(params[:university_id])
    @campus = @university.campuses.find(params[:campus_id])
    @complaint = @campus.complaints.find(params[:complaint_id])
  end
  # GET complaints/1/comments
  # GET complaints/1/comments.json
  def index
    @comments = @complaint.comments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @comments }
      format.js
    end
  end

  # GET complaints/1/comments/1
  # GET complaints/1/comments/1.json
  def show
    @comment = @complaint.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @comment }
      format.js
    end
  end

  # GET complaints/1/comments/new
  # GET complaints/1/comments/new.json
  def new
    @comment = @complaint.comments.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @comment }
      format.js
    end
  end

  # GET complaints/1/comments/1/edit
  def edit
    @comment = @complaint.comments.find(params[:id])
  end

  # POST complaints/1/comments
  # POST complaints/1/comments.json
  def create
    @comment = @complaint.comments.build(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to([@comment.complaint, @comment], :notice => 'Su comentario ha sido agregado.') }
        format.json { render :json => @comment, :status => :created, :location => [@comment.complaint, @comment] }
        format.js
      else
        format.html { render :action => "new" }
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT complaints/1/comments/1
  # PUT complaints/1/comments/1.json
  def update
    @comment = @complaint.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to([@comment.complaint, @comment], :notice => 'Su comentario ha sido actualizado.') }
        format.json { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE complaints/1/comments/1
  # DELETE complaints/1/comments/1.json
  def destroy
    @comment = @complaint.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to complaint_comments_url(complaint) }
      format.json { head :ok }
      format.js
    end
  end
end
