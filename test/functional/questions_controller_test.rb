require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  setup do
    @survey = surveys(:one)
    @question = questions(:one)
  end

  test "should get index" do
    get :index, :survey_id => @survey
    assert_response :success
    assert_not_nil assigns(:questions)
  end

  test "should get new" do
    get :new, :survey_id => @survey
    assert_response :success
  end

  test "should create question" do
    assert_difference('Question.count') do
      post :create, :survey_id => @survey, :question => @question.attributes
    end

    assert_redirected_to survey_question_path(@survey, assigns(:question))
  end

  test "should show question" do
    get :show, :survey_id => @survey, :id => @question.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :survey_id => @survey, :id => @question.to_param
    assert_response :success
  end

  test "should update question" do
    put :update, :survey_id => @survey, :id => @question.to_param, :question => @question.attributes
    assert_redirected_to survey_question_path(@survey, assigns(:question))
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete :destroy, :survey_id => @survey, :id => @question.to_param
    end

    assert_redirected_to survey_questions_path(@survey)
  end
end
