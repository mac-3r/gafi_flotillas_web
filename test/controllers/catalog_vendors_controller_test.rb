require 'test_helper'

class CatalogVendorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_vendor = catalog_vendors(:one)
  end

  test "should get index" do
    get catalog_vendors_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_vendor_url
    assert_response :success
  end

  test "should create catalog_vendor" do
    assert_difference('CatalogVendor.count') do
      post catalog_vendors_url, params: { catalog_vendor: { clave: @catalog_vendor.clave, nombre: @catalog_vendor.nombre } }
    end

    assert_redirected_to catalog_vendor_url(CatalogVendor.last)
  end

  test "should show catalog_vendor" do
    get catalog_vendor_url(@catalog_vendor)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_vendor_url(@catalog_vendor)
    assert_response :success
  end

  test "should update catalog_vendor" do
    patch catalog_vendor_url(@catalog_vendor), params: { catalog_vendor: { clave: @catalog_vendor.clave, nombre: @catalog_vendor.nombre } }
    assert_redirected_to catalog_vendor_url(@catalog_vendor)
  end

  test "should destroy catalog_vendor" do
    assert_difference('CatalogVendor.count', -1) do
      delete catalog_vendor_url(@catalog_vendor)
    end

    assert_redirected_to catalog_vendors_url
  end
end
