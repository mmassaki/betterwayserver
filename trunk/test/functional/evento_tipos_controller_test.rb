require 'test_helper'

class EventoTiposControllerTest < ActionController::TestCase
  setup do
    @evento_tipo = evento_tipos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evento_tipos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evento_tipo" do
    assert_difference('EventoTipo.count') do
      post :create, :evento_tipo => @evento_tipo.attributes
    end

    assert_redirected_to evento_tipo_path(assigns(:evento_tipo))
  end

  test "should show evento_tipo" do
    get :show, :id => @evento_tipo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @evento_tipo.to_param
    assert_response :success
  end

  test "should update evento_tipo" do
    put :update, :id => @evento_tipo.to_param, :evento_tipo => @evento_tipo.attributes
    assert_redirected_to evento_tipo_path(assigns(:evento_tipo))
  end

  test "should destroy evento_tipo" do
    assert_difference('EventoTipo.count', -1) do
      delete :destroy, :id => @evento_tipo.to_param
    end

    assert_redirected_to evento_tipos_path
  end
end
