require 'test_helper'

class PermissionsControllerTest < ActionController::TestCase

  setup :login

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:permissions)
  end

end
