require 'test_helper'

class PoisControllerTest < ActionController::TestCase
  setup do
    @campus = campuses(:one)
    @poi = pois(:one)
  end

  test "should get index" do
    get :index, :campus_id => @campus
    assert_response :success
    assert_not_nil assigns(:pois)
  end

  test "should get new" do
    get :new, :campus_id => @campus
    assert_response :success
  end

  test "should create poi" do
    assert_difference('Poi.count') do
      post :create, :campus_id => @campus, :poi => @poi.attributes
    end

    assert_redirected_to campus_poi_path(@campus, assigns(:poi))
  end

  test "should show poi" do
    get :show, :campus_id => @campus, :id => @poi.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :campus_id => @campus, :id => @poi.to_param
    assert_response :success
  end

  test "should update poi" do
    put :update, :campus_id => @campus, :id => @poi.to_param, :poi => @poi.attributes
    assert_redirected_to campus_poi_path(@campus, assigns(:poi))
  end

  test "should destroy poi" do
    assert_difference('Poi.count', -1) do
      delete :destroy, :campus_id => @campus, :id => @poi.to_param
    end

    assert_redirected_to campus_pois_path(@campus)
  end
end
