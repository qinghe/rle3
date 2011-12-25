require 'test_helper'

class SectionPiecesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:section_pieces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create section_piece" do
    assert_difference('SectionPiece.count') do
      post :create, :section_piece => { }
    end

    assert_redirected_to section_piece_path(assigns(:section_piece))
  end

  test "should show section_piece" do
    get :show, :id => section_pieces(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => section_pieces(:one).to_param
    assert_response :success
  end

  test "should update section_piece" do
    put :update, :id => section_pieces(:one).to_param, :section_piece => { }
    assert_redirected_to section_piece_path(assigns(:section_piece))
  end

  test "should destroy section_piece" do
    assert_difference('SectionPiece.count', -1) do
      delete :destroy, :id => section_pieces(:one).to_param
    end

    assert_redirected_to section_pieces_path
  end
end
