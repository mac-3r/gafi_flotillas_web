require 'test_helper'

class CatalogConsiderationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_consideration = catalog_considerations(:one)
  end

  test "should get index" do
    get catalog_considerations_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_consideration_url
    assert_response :success
  end

  test "should create catalog_consideration" do
    assert_difference('CatalogConsideration.count') do
      post catalog_considerations_url, params: { catalog_consideration: { catalog_brand_id: @catalog_consideration.catalog_brand_id, clave: @catalog_consideration.clave, descripcion: @catalog_consideration.descripcion } }
    end

    assert_redirected_to catalog_consideration_url(CatalogConsideration.last)
  end

  test "should show catalog_consideration" do
    get catalog_consideration_url(@catalog_consideration)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_consideration_url(@catalog_consideration)
    assert_response :success
  end

  test "should update catalog_consideration" do
    patch catalog_consideration_url(@catalog_consideration), params: { catalog_consideration: { catalog_brand_id: @catalog_consideration.catalog_brand_id, clave: @catalog_consideration.clave, descripcion: @catalog_consideration.descripcion } }
    assert_redirected_to catalog_consideration_url(@catalog_consideration)
  end

  test "should destroy catalog_consideration" do
    assert_difference('CatalogConsideration.count', -1) do
      delete catalog_consideration_url(@catalog_consideration)
    end

    assert_redirected_to catalog_considerations_url
  end
end
