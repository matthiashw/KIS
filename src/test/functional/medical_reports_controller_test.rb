require 'test_helper'

class MedicalReportsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:medical_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create medical_report" do
    assert_difference('MedicalReport.count') do
      post :create, :medical_report => { }
    end

    assert_redirected_to medical_report_path(assigns(:medical_report))
  end

  test "should show medical_report" do
    get :show, :id => medical_reports(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => medical_reports(:one).to_param
    assert_response :success
  end

  test "should update medical_report" do
    put :update, :id => medical_reports(:one).to_param, :medical_report => { }
    assert_redirected_to medical_report_path(assigns(:medical_report))
  end

  test "should destroy medical_report" do
    assert_difference('MedicalReport.count', -1) do
      delete :destroy, :id => medical_reports(:one).to_param
    end

    assert_redirected_to medical_reports_path
  end
end
