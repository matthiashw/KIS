require 'test_helper'

class CaseFilesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:case_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create case_file" do
    assert_difference('CaseFile.count') do
      post :create, :case_file => { }
    end

    assert_redirected_to case_file_path(assigns(:case_file))
  end

  test "should show case_file" do
    get :show, :id => case_files(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => case_files(:one).to_param
    assert_response :success
  end

  test "should update case_file" do
    put :update, :id => case_files(:one).to_param, :case_file => { }
    assert_redirected_to case_file_path(assigns(:case_file))
  end

  test "should destroy case_file" do
    assert_difference('CaseFile.count', -1) do
      delete :destroy, :id => case_files(:one).to_param
    end

    assert_redirected_to case_files_path
  end
end
