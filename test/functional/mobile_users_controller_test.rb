require 'test_helper'

class MobileUsersControllerTest < ActionController::TestCase
  setup do
    @mobile_user = mobile_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mobile_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mobile_user" do
    assert_difference('MobileUser.count') do
      post :create, mobile_user: { api_token: @mobile_user.api_token, email: @mobile_user.email, name: @mobile_user.name }
    end

    assert_redirected_to mobile_user_path(assigns(:mobile_user))
  end

  test "should show mobile_user" do
    get :show, id: @mobile_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mobile_user
    assert_response :success
  end

  test "should update mobile_user" do
    put :update, id: @mobile_user, mobile_user: { api_token: @mobile_user.api_token, email: @mobile_user.email, name: @mobile_user.name }
    assert_redirected_to mobile_user_path(assigns(:mobile_user))
  end

  test "should destroy mobile_user" do
    assert_difference('MobileUser.count', -1) do
      delete :destroy, id: @mobile_user
    end

    assert_redirected_to mobile_users_path
  end
end
