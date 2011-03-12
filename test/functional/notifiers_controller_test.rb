require 'test_helper'

class NotifiersControllerTest < ActionController::TestCase
  setup do
    @notifier = notifiers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notifiers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notifier" do
    assert_difference('Notifier.count') do
      post :create, :notifier => @notifier.attributes
    end

    assert_redirected_to notifier_path(assigns(:notifier))
  end

  test "should show notifier" do
    get :show, :id => @notifier.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @notifier.to_param
    assert_response :success
  end

  test "should update notifier" do
    put :update, :id => @notifier.to_param, :notifier => @notifier.attributes
    assert_redirected_to notifier_path(assigns(:notifier))
  end

  test "should destroy notifier" do
    assert_difference('Notifier.count', -1) do
      delete :destroy, :id => @notifier.to_param
    end

    assert_redirected_to notifiers_path
  end
end
