require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @complaint = complaints(:one)
    @comment = comments(:one)
  end

  test "should get index" do
    get :index, :complaint_id => @complaint
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should get new" do
    get :new, :complaint_id => @complaint
    assert_response :success
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post :create, :complaint_id => @complaint, :comment => @comment.attributes
    end

    assert_redirected_to complaint_comment_path(@complaint, assigns(:comment))
  end

  test "should show comment" do
    get :show, :complaint_id => @complaint, :id => @comment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :complaint_id => @complaint, :id => @comment.to_param
    assert_response :success
  end

  test "should update comment" do
    put :update, :complaint_id => @complaint, :id => @comment.to_param, :comment => @comment.attributes
    assert_redirected_to complaint_comment_path(@complaint, assigns(:comment))
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete :destroy, :complaint_id => @complaint, :id => @comment.to_param
    end

    assert_redirected_to complaint_comments_path(@complaint)
  end
end
