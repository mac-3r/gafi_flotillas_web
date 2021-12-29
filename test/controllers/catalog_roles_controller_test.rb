require 'test_helper'

class CatalogRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_role = catalog_roles(:one)
  end

  test "should get index" do
    get catalog_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_role_url
    assert_response :success
  end

  test "should create catalog_role" do
    assert_difference('CatalogRole.count') do
      post catalog_roles_url, params: { catalog_role: { clave: @catalog_role.clave, descripcion: @catalog_role.descripcion, nombre: @catalog_role.nombre, status: @catalog_role.status } }
    end

    assert_redirected_to catalog_role_url(CatalogRole.last)
  end

  test "should show catalog_role" do
    get catalog_role_url(@catalog_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_role_url(@catalog_role)
    assert_response :success
  end

  test "should update catalog_role" do
    patch catalog_role_url(@catalog_role), params: { catalog_role: { clave: @catalog_role.clave, descripcion: @catalog_role.descripcion, nombre: @catalog_role.nombre, status: @catalog_role.status } }
    assert_redirected_to catalog_role_url(@catalog_role)
  end

  test "should destroy catalog_role" do
    assert_difference('CatalogRole.count', -1) do
      delete catalog_role_url(@catalog_role)
    end

    assert_redirected_to catalog_roles_url
  end
end
