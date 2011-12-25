require 'test_helper'

class SectionPieceParamsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:section_piece_params)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create section_piece_param" do
    assert_difference('SectionPieceParam.count') do
      post :create, :section_piece_param => { }
    end

    assert_redirected_to section_piece_param_path(assigns(:section_piece_param))
  end

  test "should show section_piece_param" do
    get :show, :id => section_piece_params(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => section_piece_params(:one).to_param
    assert_response :success
  end

  test "should update section_piece_param" do
    put :update, :id => section_piece_params(:one).to_param, :section_piece_param => { }
    assert_redirected_to section_piece_param_path(assigns(:section_piece_param))
  end

  test "should destroy section_piece_param" do
    assert_difference('SectionPieceParam.count', -1) do
      delete :destroy, :id => section_piece_params(:one).to_param
    end

    assert_redirected_to section_piece_params_path
  end
end
