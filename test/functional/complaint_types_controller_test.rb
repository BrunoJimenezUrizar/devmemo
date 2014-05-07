require 'test_helper'

class ComplaintTypesControllerTest < ActionController::TestCase
  setup do
    @university = universities(:one)
    @complaint_type = complaint_types(:one)
  end

  test "should get index" do
    get :index, :university_id => @university
    assert_response :success
    assert_not_nil assigns(:complaint_types)
  end

  test "should get new" do
    get :new, :university_id => @university
    assert_response :success
  end

  test "should create complaint_type" do
    assert_difference('ComplaintType.count') do
      post :create, :university_id => @university, :complaint_type => @complaint_type.attributes
    end

    assert_redirected_to university_complaint_type_path(@university, assigns(:complaint_type))
  end

  test "should show complaint_type" do
    get :show, :university_id => @university, :id => @complaint_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :university_id => @university, :id => @complaint_type.to_param
    assert_response :success
  end

  test "should update complaint_type" do
    put :update, :university_id => @university, :id => @complaint_type.to_param, :complaint_type => @complaint_type.attributes
    assert_redirected_to university_complaint_type_path(@university, assigns(:complaint_type))
  end

  test "should destroy complaint_type" do
    assert_difference('ComplaintType.count', -1) do
      delete :destroy, :university_id => @university, :id => @complaint_type.to_param
    end

    assert_redirected_to university_complaint_types_path(@university)
  end
end
