require 'test_helper'

class PageLayoutsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_layouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_layout" do
    assert_difference('PageLayout.count') do
      post :create, :page_layout => { }
    end

    assert_redirected_to page_layout_path(assigns(:page_layout))
  end

  test "should show page_layout" do
    get :show, :id => page_layouts(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => page_layouts(:one).to_param
    assert_response :success
  end

  test "should update page_layout" do
    put :update, :id => page_layouts(:one).to_param, :page_layout => { }
    assert_redirected_to page_layout_path(assigns(:page_layout))
  end

  test "should destroy page_layout" do
    assert_difference('PageLayout.count', -1) do
      delete :destroy, :id => page_layouts(:one).to_param
    end

    assert_redirected_to page_layouts_path
  end
end
