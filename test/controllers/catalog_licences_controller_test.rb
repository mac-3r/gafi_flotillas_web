require 'test_helper'

class CatalogLicencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_licence = catalog_licences(:one)
  end

  test "should get index" do
    get catalog_licences_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_licence_url
    assert_response :success
  end

  test "should create catalog_licence" do
    assert_difference('CatalogLicence.count') do
      post catalog_licences_url, params: { catalog_licence: { clave: @catalog_licence.clave, descripcion: @catalog_licence.descripcion } }
    end

    assert_redirected_to catalog_licence_url(CatalogLicence.last)
  end

  test "should show catalog_licence" do
    get catalog_licence_url(@catalog_licence)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_licence_url(@catalog_licence)
    assert_response :success
  end

  test "should update catalog_licence" do
    patch catalog_licence_url(@catalog_licence), params: { catalog_licence: { clave: @catalog_licence.clave, descripcion: @catalog_licence.descripcion } }
    assert_redirected_to catalog_licence_url(@catalog_licence)
  end

  test "should destroy catalog_licence" do
    assert_difference('CatalogLicence.count', -1) do
      delete catalog_licence_url(@catalog_licence)
    end

    assert_redirected_to catalog_licences_url
  end
end
