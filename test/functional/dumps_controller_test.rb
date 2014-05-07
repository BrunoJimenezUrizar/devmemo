require 'test_helper'

class DumpsControllerTest < ActionController::TestCase
  setup do
    @dump = dumps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dumps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dump" do
    assert_difference('Dump.count') do
      post :create, dump: { description: @dump.description, por_id: @dump.por_id, qr_code: @dump.qr_code, type_id: @dump.type_id }
    end

    assert_redirected_to dump_path(assigns(:dump))
  end

  test "should show dump" do
    get :show, id: @dump
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dump
    assert_response :success
  end

  test "should update dump" do
    put :update, id: @dump, dump: { description: @dump.description, por_id: @dump.por_id, qr_code: @dump.qr_code, type_id: @dump.type_id }
    assert_redirected_to dump_path(assigns(:dump))
  end

  test "should destroy dump" do
    assert_difference('Dump.count', -1) do
      delete :destroy, id: @dump
    end

    assert_redirected_to dumps_path
  end
end
