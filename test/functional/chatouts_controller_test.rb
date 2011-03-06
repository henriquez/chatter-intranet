require 'test_helper'

class ChatoutsControllerTest < ActionController::TestCase
  setup do
    @chatout = chatouts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chatouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chatout" do
    assert_difference('Chatout.count') do
      post :create, :chatout => @chatout.attributes
    end

    assert_redirected_to chatout_path(assigns(:chatout))
  end

  test "should show chatout" do
    get :show, :id => @chatout.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @chatout.to_param
    assert_response :success
  end

  test "should update chatout" do
    put :update, :id => @chatout.to_param, :chatout => @chatout.attributes
    assert_redirected_to chatout_path(assigns(:chatout))
  end

  test "should destroy chatout" do
    assert_difference('Chatout.count', -1) do
      delete :destroy, :id => @chatout.to_param
    end

    assert_redirected_to chatouts_path
  end
end
