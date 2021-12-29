require 'test_helper'

class CatalogAreasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_area = catalog_areas(:one)
  end

  test "should get index" do
    get catalog_areas_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_area_url
    assert_response :success
  end

  test "should create catalog_area" do
    assert_difference('CatalogArea.count') do
      post catalog_areas_url, params: { catalog_area: { descripcion: @catalog_area.descripcion, status: @catalog_area.status } }
    end

    assert_redirected_to catalog_area_url(CatalogArea.last)
  end

  test "should show catalog_area" do
    get catalog_area_url(@catalog_area)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_area_url(@catalog_area)
    assert_response :success
  end

  test "should update catalog_area" do
    patch catalog_area_url(@catalog_area), params: { catalog_area: { descripcion: @catalog_area.descripcion, status: @catalog_area.status } }
    assert_redirected_to catalog_area_url(@catalog_area)
  end

  test "should destroy catalog_area" do
    assert_difference('CatalogArea.count', -1) do
      delete catalog_area_url(@catalog_area)
    end

    assert_redirected_to catalog_areas_url
  end
end
