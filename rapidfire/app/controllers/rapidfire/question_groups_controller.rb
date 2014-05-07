module Rapidfire
  class QuestionGroupsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!, except: :index
    before_filter :get_campus
    respond_to :html, :js, except: :create
    respond_to :json, only: :results

    def get_campus
      @university = University.find(params[:university_id])
      #@campus = @university.campuses.find(params[:campus_id])
    end

    def index
      @question_groups = @university.question_groups
      respond_with(@question_groups)
    end

    def new
      @question_group = @university.question_groups.build
      respond_with(@question_group)
    end

    def create
      #campus_survey = CampusSurvey.new
      #campus_survey.campus_id = @campus.id
      #@question_group = QuestionGroup.new(question_group_params)
      #@question_group = @campus.surveys.build(params[:question_group])
      @question_group = QuestionGroup.new(params[:question_group])
      @question_group.save
      #campus_survey.question_group_id = @question_group.id
      #campus_survey.save


      #respond_with(@question_group, location: rapidfire.question_group_questions_path(@question_group))

      respond_to do |format|
      if @question_group.save
        format.html { redirect_to question_group_questions_path(@question_group), notice: 'La encuesta se ha creado exitosamente.' }

      else
        format.html { render action: "new" }
        format.json { render json: @question_group.errors, status: :unprocessable_entity }

      end
    end

    end

    def edit
      @question_group = QuestionGroup.find(params[:id])
    end

    def update
    @question_group = QuestionGroup.find(params[:id])

    respond_to do |format|
      if @question_group.update_attributes(params[:question_group])
        format.html { redirect_to(question_group_questions_path(@question_group)) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
      end
    end


    end

    def destroy
      @question_group = QuestionGroup.find(params[:id])
      @question_group.destroy

      respond_with(@question_group)
    end

    def results
      @question_group = QuestionGroup.find(params[:id])
      @question_group_results =
        QuestionGroupResults.new(question_group: @question_group).extract

      respond_with(@question_group_results, root: false)
    end

    def activate
      question_group = QuestionGroup.find(params[:question_group_id])
      question_group.activate
      redirect_to question_group_questions_path(question_group)
    end
    def deactivate
      question_group = QuestionGroup.find(params[:question_group_id])
      question_group.deactivate
      redirect_to question_group_questions_path(question_group)
    end

    private
    def question_group_params
      if Rails::VERSION::MAJOR == 4
        params.require(:question_group).permit(:name)
      else
        params[:question_group]
      end
    end
  end
end
