require 'test_helper'

class AppStoresControllerTest < ActionController::TestCase
  setup do
    @app_store = app_stores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_stores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_store" do
    assert_difference('AppStore.count') do
      post :create, :app_store => @app_store.attributes
    end

    assert_redirected_to app_store_path(assigns(:app_store))
  end

  test "should show app_store" do
    get :show, :id => @app_store.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @app_store.to_param
    assert_response :success
  end

  test "should update app_store" do
    put :update, :id => @app_store.to_param, :app_store => @app_store.attributes
    assert_redirected_to app_store_path(assigns(:app_store))
  end

  test "should destroy app_store" do
    assert_difference('AppStore.count', -1) do
      delete :destroy, :id => @app_store.to_param
    end

    assert_redirected_to app_stores_path
  end
end
