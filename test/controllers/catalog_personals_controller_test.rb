require 'test_helper'

class CatalogPersonalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_personal = catalog_personals(:one)
  end

  test "should get index" do
    get catalog_personals_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_personal_url
    assert_response :success
  end

  test "should create catalog_personal" do
    assert_difference('CatalogPersonal.count') do
      post catalog_personals_url, params: { catalog_personal: { apellido: @catalog_personal.apellido, clave: @catalog_personal.clave, nombre: @catalog_personal.nombre } }
    end

    assert_redirected_to catalog_personal_url(CatalogPersonal.last)
  end

  test "should show catalog_personal" do
    get catalog_personal_url(@catalog_personal)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_personal_url(@catalog_personal)
    assert_response :success
  end

  test "should update catalog_personal" do
    patch catalog_personal_url(@catalog_personal), params: { catalog_personal: { apellido: @catalog_personal.apellido, clave: @catalog_personal.clave, nombre: @catalog_personal.nombre } }
    assert_redirected_to catalog_personal_url(@catalog_personal)
  end

  test "should destroy catalog_personal" do
    assert_difference('CatalogPersonal.count', -1) do
      delete catalog_personal_url(@catalog_personal)
    end

    assert_redirected_to catalog_personals_url
  end
end
