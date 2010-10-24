require 'test_helper'

class CatalogTypesControllerTest < ActionController::TestCase

   setup :login

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:catalog_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create catalog_type" do
    assert_difference('CatalogType.count') do
      post :create, :catalog_type => { }
    end

    assert_redirected_to catalog_type_path(assigns(:catalog_type))
  end

  test "should show catalog_type" do
    get :show, :id => catalog_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => catalog_types(:one).to_param
    assert_response :success
  end

  test "should update catalog_type" do
    put :update, :id => catalog_types(:one).to_param, :catalog_type => { }
    assert_redirected_to catalog_type_path(assigns(:catalog_type))
  end

  test "should destroy catalog_type" do
    assert_difference('CatalogType.count', -1) do
      delete :destroy, :id => catalog_types(:one).to_param
    end

    assert_redirected_to catalog_types_path
  end
end
