require 'test_helper'

class SectionParamsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:section_params)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create section_param" do
    assert_difference('SectionParam.count') do
      post :create, :section_param => { }
    end

    assert_redirected_to section_param_path(assigns(:section_param))
  end

  test "should show section_param" do
    get :show, :id => section_params(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => section_params(:one).to_param
    assert_response :success
  end

  test "should update section_param" do
    put :update, :id => section_params(:one).to_param, :section_param => { }
    assert_redirected_to section_param_path(assigns(:section_param))
  end

  test "should destroy section_param" do
    assert_difference('SectionParam.count', -1) do
      delete :destroy, :id => section_params(:one).to_param
    end

    assert_redirected_to section_params_path
  end
end
