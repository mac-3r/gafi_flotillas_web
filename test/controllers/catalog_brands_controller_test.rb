require 'test_helper'

class CatalogBrandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_brand = catalog_brands(:one)
  end

  test "should get index" do
    get catalog_brands_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_brand_url
    assert_response :success
  end

  test "should create catalog_brand" do
    assert_difference('CatalogBrand.count') do
      post catalog_brands_url, params: { catalog_brand: { clave: @catalog_brand.clave, descripcion: @catalog_brand.descripcion, status: @catalog_brand.status } }
    end

    assert_redirected_to catalog_brand_url(CatalogBrand.last)
  end

  test "should show catalog_brand" do
    get catalog_brand_url(@catalog_brand)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_brand_url(@catalog_brand)
    assert_response :success
  end

  test "should update catalog_brand" do
    patch catalog_brand_url(@catalog_brand), params: { catalog_brand: { clave: @catalog_brand.clave, descripcion: @catalog_brand.descripcion, status: @catalog_brand.status } }
    assert_redirected_to catalog_brand_url(@catalog_brand)
  end

  test "should destroy catalog_brand" do
    assert_difference('CatalogBrand.count', -1) do
      delete catalog_brand_url(@catalog_brand)
    end

    assert_redirected_to catalog_brands_url
  end
end
