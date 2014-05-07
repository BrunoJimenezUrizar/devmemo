require 'test_helper'

class BuildingsControllerTest < ActionController::TestCase
  setup do
    @campus = campuses(:one)
    @building = buildings(:one)
  end

  test "should get index" do
    get :index, :campus_id => @campus
    assert_response :success
    assert_not_nil assigns(:buildings)
  end

  test "should get new" do
    get :new, :campus_id => @campus
    assert_response :success
  end

  test "should create building" do
    assert_difference('Building.count') do
      post :create, :campus_id => @campus, :building => @building.attributes
    end

    assert_redirected_to campus_building_path(@campus, assigns(:building))
  end

  test "should show building" do
    get :show, :campus_id => @campus, :id => @building.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :campus_id => @campus, :id => @building.to_param
    assert_response :success
  end

  test "should update building" do
    put :update, :campus_id => @campus, :id => @building.to_param, :building => @building.attributes
    assert_redirected_to campus_building_path(@campus, assigns(:building))
  end

  test "should destroy building" do
    assert_difference('Building.count', -1) do
      delete :destroy, :campus_id => @campus, :id => @building.to_param
    end

    assert_redirected_to campus_buildings_path(@campus)
  end
end
