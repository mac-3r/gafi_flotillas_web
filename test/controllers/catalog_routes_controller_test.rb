require 'test_helper'

class CatalogRoutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_route = catalog_routes(:one)
  end

  test "should get index" do
    get catalog_routes_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_route_url
    assert_response :success
  end

  test "should create catalog_route" do
    assert_difference('CatalogRoute.count') do
      post catalog_routes_url, params: { catalog_route: { clave: @catalog_route.clave, descripcion: @catalog_route.descripcion, status: @catalog_route.status } }
    end

    assert_redirected_to catalog_route_url(CatalogRoute.last)
  end

  test "should show catalog_route" do
    get catalog_route_url(@catalog_route)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_route_url(@catalog_route)
    assert_response :success
  end

  test "should update catalog_route" do
    patch catalog_route_url(@catalog_route), params: { catalog_route: { clave: @catalog_route.clave, descripcion: @catalog_route.descripcion, status: @catalog_route.status } }
    assert_redirected_to catalog_route_url(@catalog_route)
  end

  test "should destroy catalog_route" do
    assert_difference('CatalogRoute.count', -1) do
      delete catalog_route_url(@catalog_route)
    end

    assert_redirected_to catalog_routes_url
  end
end
