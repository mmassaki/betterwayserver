require 'test_helper'

class TransitosControllerTest < ActionController::TestCase
  setup do
    @transito = transitos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transitos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transito" do
    assert_difference('Transito.count') do
      post :create, :transito => @transito.attributes
    end

    assert_redirected_to transito_path(assigns(:transito))
  end

  test "should show transito" do
    get :show, :id => @transito.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @transito.to_param
    assert_response :success
  end

  test "should update transito" do
    put :update, :id => @transito.to_param, :transito => @transito.attributes
    assert_redirected_to transito_path(assigns(:transito))
  end

  test "should destroy transito" do
    assert_difference('Transito.count', -1) do
      delete :destroy, :id => @transito.to_param
    end

    assert_redirected_to transitos_path
  end
end
