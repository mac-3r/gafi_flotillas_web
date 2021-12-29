require 'test_helper'

class CatalogModelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_model = catalog_models(:one)
  end

  test "should get index" do
    get catalog_models_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_model_url
    assert_response :success
  end

  test "should create catalog_model" do
    assert_difference('CatalogModel.count') do
      post catalog_models_url, params: { catalog_model: { clave: @catalog_model.clave, descripcion: @catalog_model.descripcion, status: @catalog_model.status } }
    end

    assert_redirected_to catalog_model_url(CatalogModel.last)
  end

  test "should show catalog_model" do
    get catalog_model_url(@catalog_model)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_model_url(@catalog_model)
    assert_response :success
  end

  test "should update catalog_model" do
    patch catalog_model_url(@catalog_model), params: { catalog_model: { clave: @catalog_model.clave, descripcion: @catalog_model.descripcion, status: @catalog_model.status } }
    assert_redirected_to catalog_model_url(@catalog_model)
  end

  test "should destroy catalog_model" do
    assert_difference('CatalogModel.count', -1) do
      delete catalog_model_url(@catalog_model)
    end

    assert_redirected_to catalog_models_url
  end
end
