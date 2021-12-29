require 'test_helper'

class CatalogTiresBatteriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_tires_battery = catalog_tires_batteries(:one)
  end

  test "should get index" do
    get catalog_tires_batteries_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_tires_battery_url
    assert_response :success
  end

  test "should create catalog_tires_battery" do
    assert_difference('CatalogTiresBattery.count') do
      post catalog_tires_batteries_url, params: { catalog_tires_battery: { catalog_brand_id: @catalog_tires_battery.catalog_brand_id, dls: @catalog_tires_battery.dls, medida: @catalog_tires_battery.medida, modelo: @catalog_tires_battery.modelo, moneda: @catalog_tires_battery.moneda, precio: @catalog_tires_battery.precio, tipo: @catalog_tires_battery.tipo } }
    end

    assert_redirected_to catalog_tires_battery_url(CatalogTiresBattery.last)
  end

  test "should show catalog_tires_battery" do
    get catalog_tires_battery_url(@catalog_tires_battery)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_tires_battery_url(@catalog_tires_battery)
    assert_response :success
  end

  test "should update catalog_tires_battery" do
    patch catalog_tires_battery_url(@catalog_tires_battery), params: { catalog_tires_battery: { catalog_brand_id: @catalog_tires_battery.catalog_brand_id, dls: @catalog_tires_battery.dls, medida: @catalog_tires_battery.medida, modelo: @catalog_tires_battery.modelo, moneda: @catalog_tires_battery.moneda, precio: @catalog_tires_battery.precio, tipo: @catalog_tires_battery.tipo } }
    assert_redirected_to catalog_tires_battery_url(@catalog_tires_battery)
  end

  test "should destroy catalog_tires_battery" do
    assert_difference('CatalogTiresBattery.count', -1) do
      delete catalog_tires_battery_url(@catalog_tires_battery)
    end

    assert_redirected_to catalog_tires_batteries_url
  end
end
