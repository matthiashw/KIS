require 'test_helper'

class ReportHeadersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_headers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_header" do
    assert_difference('ReportHeader.count') do
      post :create, :report_header => { }
    end

    assert_redirected_to report_header_path(assigns(:report_header))
  end

  test "should show report_header" do
    get :show, :id => report_headers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => report_headers(:one).to_param
    assert_response :success
  end

  test "should update report_header" do
    put :update, :id => report_headers(:one).to_param, :report_header => { }
    assert_redirected_to report_header_path(assigns(:report_header))
  end

  test "should destroy report_header" do
    assert_difference('ReportHeader.count', -1) do
      delete :destroy, :id => report_headers(:one).to_param
    end

    assert_redirected_to report_headers_path
  end
end
