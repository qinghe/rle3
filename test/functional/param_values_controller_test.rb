require 'test_helper'

class ParamValuesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:param_values)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create param_value" do
    assert_difference('ParamValue.count') do
      post :create, :param_value => { }
    end

    assert_redirected_to param_value_path(assigns(:param_value))
  end

  test "should show param_value" do
    get :show, :id => param_values(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => param_values(:one).to_param
    assert_response :success
  end

  test "should update param_value" do
    put :update, :id => param_values(:one).to_param, :param_value => { }
    assert_redirected_to param_value_path(assigns(:param_value))
  end

  test "should destroy param_value" do
    assert_difference('ParamValue.count', -1) do
      delete :destroy, :id => param_values(:one).to_param
    end

    assert_redirected_to param_values_path
  end
end
