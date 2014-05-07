#coding: utf-8
class CategoriesController < ApplicationController
  before_filter :get_university

  def get_university
    @university = University.find(params[:university_id])
  end
  # GET /categories
  # GET /categories.json
  def index
    authorize! :index, Category, :message => 'Acceso denegado.'
    @categories = @university.categories

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show    
    @category = @university.categories.find(params[:id])
    authorize! :show, @category, :message => 'Acceso denegado.'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new
    @modal_title = "Nueva Categoria"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
      format.js
    end
  end

  # GET /categories/1/edit
  def edit
    @category = @university.categories.find(params[:id])
    authorize! :edit, @category, :message => 'Acceso denegado.'
    @modal_title = "Editar Categoria"

    respond_to do |format|
      format.js
    end
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = @university.categories.new(params[:category])
    authorize! :create, @category, :message => 'Acceso denegado.'

    respond_to do |format|
      if @category.save
        format.html { redirect_to university_category_path(@university, @category), notice: 'La categoria fue creada exitosamente.' }
        format.json { render json: @category, status: :created, location: @category }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = @university.categories.find(params[:id])
    authorize! :update, @category, :message => 'Acceso denegado.'

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to university_category_path(@university, @category), notice: 'La categoría fue modificada exitosamente.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = @university.categories.find(params[:id])
    authorize! :destroy, @category, :message => 'Acceso denegado.'
    @category.destroy

    respond_to do |format|
      format.html { redirect_to university_categories_path(@university) }
      format.json { head :no_content }
      format.js
    end
  end
end
