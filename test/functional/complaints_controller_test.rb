require 'test_helper'

class ComplaintsControllerTest < ActionController::TestCase
  setup do
    @campus = campuses(:one)
    @complaint = complaints(:one)
  end

  test "should get index" do
    get :index, :campus_id => @campus
    assert_response :success
    assert_not_nil assigns(:complaints)
  end

  test "should get new" do
    get :new, :campus_id => @campus
    assert_response :success
  end

  test "should create complaint" do
    assert_difference('Complaint.count') do
      post :create, :campus_id => @campus, :complaint => @complaint.attributes
    end

    assert_redirected_to campus_complaint_path(@campus, assigns(:complaint))
  end

  test "should show complaint" do
    get :show, :campus_id => @campus, :id => @complaint.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :campus_id => @campus, :id => @complaint.to_param
    assert_response :success
  end

  test "should update complaint" do
    put :update, :campus_id => @campus, :id => @complaint.to_param, :complaint => @complaint.attributes
    assert_redirected_to campus_complaint_path(@campus, assigns(:complaint))
  end

  test "should destroy complaint" do
    assert_difference('Complaint.count', -1) do
      delete :destroy, :campus_id => @campus, :id => @complaint.to_param
    end

    assert_redirected_to campus_complaints_path(@campus)
  end
end
