require 'test_helper'

class AdvertisesControllerTest < ActionController::TestCase
  setup do
    @advertise = advertises(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:advertises)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advertise" do
    assert_difference('Advertise.count') do
      post :create, advertise: { active: @advertise.active, end_date: @advertise.end_date, start_date: @advertise.start_date }
    end

    assert_redirected_to advertise_path(assigns(:advertise))
  end

  test "should show advertise" do
    get :show, id: @advertise
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @advertise
    assert_response :success
  end

  test "should update advertise" do
    put :update, id: @advertise, advertise: { active: @advertise.active, end_date: @advertise.end_date, start_date: @advertise.start_date }
    assert_redirected_to advertise_path(assigns(:advertise))
  end

  test "should destroy advertise" do
    assert_difference('Advertise.count', -1) do
      delete :destroy, id: @advertise
    end

    assert_redirected_to advertises_path
  end
end
