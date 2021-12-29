require 'test_helper'

class CatalogRepairsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_repair = catalog_repairs(:one)
  end

  test "should get index" do
    get catalog_repairs_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_repair_url
    assert_response :success
  end

  test "should create catalog_repair" do
    assert_difference('CatalogRepair.count') do
      post catalog_repairs_url, params: { catalog_repair: { categoria: @catalog_repair.categoria, clave: @catalog_repair.clave, status: @catalog_repair.status, subcategoria: @catalog_repair.subcategoria } }
    end

    assert_redirected_to catalog_repair_url(CatalogRepair.last)
  end

  test "should show catalog_repair" do
    get catalog_repair_url(@catalog_repair)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_repair_url(@catalog_repair)
    assert_response :success
  end

  test "should update catalog_repair" do
    patch catalog_repair_url(@catalog_repair), params: { catalog_repair: { categoria: @catalog_repair.categoria, clave: @catalog_repair.clave, status: @catalog_repair.status, subcategoria: @catalog_repair.subcategoria } }
    assert_redirected_to catalog_repair_url(@catalog_repair)
  end

  test "should destroy catalog_repair" do
    assert_difference('CatalogRepair.count', -1) do
      delete catalog_repair_url(@catalog_repair)
    end

    assert_redirected_to catalog_repairs_url
  end
end
