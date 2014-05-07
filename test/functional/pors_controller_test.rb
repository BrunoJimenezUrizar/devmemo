require 'test_helper'

class PorsControllerTest < ActionController::TestCase
  setup do
    @campus = campuses(:one)
    @por = pors(:one)
  end

  test "should get index" do
    get :index, :campus_id => @campus
    assert_response :success
    assert_not_nil assigns(:pors)
  end

  test "should get new" do
    get :new, :campus_id => @campus
    assert_response :success
  end

  test "should create por" do
    assert_difference('Por.count') do
      post :create, :campus_id => @campus, :por => @por.attributes
    end

    assert_redirected_to campus_por_path(@campus, assigns(:por))
  end

  test "should show por" do
    get :show, :campus_id => @campus, :id => @por.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :campus_id => @campus, :id => @por.to_param
    assert_response :success
  end

  test "should update por" do
    put :update, :campus_id => @campus, :id => @por.to_param, :por => @por.attributes
    assert_redirected_to campus_por_path(@campus, assigns(:por))
  end

  test "should destroy por" do
    assert_difference('Por.count', -1) do
      delete :destroy, :campus_id => @campus, :id => @por.to_param
    end

    assert_redirected_to campus_pors_path(@campus)
  end
end
