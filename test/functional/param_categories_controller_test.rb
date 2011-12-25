require 'test_helper'

class ParamCategoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:param_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create param_category" do
    assert_difference('ParamCategory.count') do
      post :create, :param_category => { }
    end

    assert_redirected_to param_category_path(assigns(:param_category))
  end

  test "should show param_category" do
    get :show, :id => param_categories(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => param_categories(:one).to_param
    assert_response :success
  end

  test "should update param_category" do
    put :update, :id => param_categories(:one).to_param, :param_category => { }
    assert_redirected_to param_category_path(assigns(:param_category))
  end

  test "should destroy param_category" do
    assert_difference('ParamCategory.count', -1) do
      delete :destroy, :id => param_categories(:one).to_param
    end

    assert_redirected_to param_categories_path
  end
end
