require 'test_helper'

class CatalogoAdaptationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalogo_adaptation = catalogo_adaptations(:one)
  end

  test "should get index" do
    get catalogo_adaptations_url
    assert_response :success
  end

  test "should get new" do
    get new_catalogo_adaptation_url
    assert_response :success
  end

  test "should create catalogo_adaptation" do
    assert_difference('CatalogoAdaptation.count') do
      post catalogo_adaptations_url, params: { catalogo_adaptation: { clave: @catalogo_adaptation.clave, descripcion: @catalogo_adaptation.descripcion, status: @catalogo_adaptation.status } }
    end

    assert_redirected_to catalogo_adaptation_url(CatalogoAdaptation.last)
  end

  test "should show catalogo_adaptation" do
    get catalogo_adaptation_url(@catalogo_adaptation)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalogo_adaptation_url(@catalogo_adaptation)
    assert_response :success
  end

  test "should update catalogo_adaptation" do
    patch catalogo_adaptation_url(@catalogo_adaptation), params: { catalogo_adaptation: { clave: @catalogo_adaptation.clave, descripcion: @catalogo_adaptation.descripcion, status: @catalogo_adaptation.status } }
    assert_redirected_to catalogo_adaptation_url(@catalogo_adaptation)
  end

  test "should destroy catalogo_adaptation" do
    assert_difference('CatalogoAdaptation.count', -1) do
      delete catalogo_adaptation_url(@catalogo_adaptation)
    end

    assert_redirected_to catalogo_adaptations_url
  end
end
