require 'test_helper'

class FloorsControllerTest < ActionController::TestCase
  setup do
    @building = buildings(:one)
    @floor = floors(:one)
  end

  test "should get index" do
    get :index, :building_id => @building
    assert_response :success
    assert_not_nil assigns(:floors)
  end

  test "should get new" do
    get :new, :building_id => @building
    assert_response :success
  end

  test "should create floor" do
    assert_difference('Floor.count') do
      post :create, :building_id => @building, :floor => @floor.attributes
    end

    assert_redirected_to building_floor_path(@building, assigns(:floor))
  end

  test "should show floor" do
    get :show, :building_id => @building, :id => @floor.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :building_id => @building, :id => @floor.to_param
    assert_response :success
  end

  test "should update floor" do
    put :update, :building_id => @building, :id => @floor.to_param, :floor => @floor.attributes
    assert_redirected_to building_floor_path(@building, assigns(:floor))
  end

  test "should destroy floor" do
    assert_difference('Floor.count', -1) do
      delete :destroy, :building_id => @building, :id => @floor.to_param
    end

    assert_redirected_to building_floors_path(@building)
  end
end
