require 'test_helper'

class DiagnosesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:diagnoses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create diagnosis" do
    assert_difference('Diagnosis.count') do
      post :create, :diagnosis => { }
    end

    assert_redirected_to diagnosis_path(assigns(:diagnosis))
  end

  test "should show diagnosis" do
    get :show, :id => diagnoses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => diagnoses(:one).to_param
    assert_response :success
  end

  test "should update diagnosis" do
    put :update, :id => diagnoses(:one).to_param, :diagnosis => { }
    assert_redirected_to diagnosis_path(assigns(:diagnosis))
  end

  test "should destroy diagnosis" do
    assert_difference('Diagnosis.count', -1) do
      delete :destroy, :id => diagnoses(:one).to_param
    end

    assert_redirected_to diagnoses_path
  end
end
