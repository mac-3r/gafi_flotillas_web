require 'test_helper'

class CatalogPermitsVehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_permits_vehicle = catalog_permits_vehicles(:one)
  end

  test "should get index" do
    get catalog_permits_vehicles_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_permits_vehicle_url
    assert_response :success
  end

  test "should create catalog_permits_vehicle" do
    assert_difference('CatalogPermitsVehicle.count') do
      post catalog_permits_vehicles_url, params: { catalog_permits_vehicle: { descripcion: @catalog_permits_vehicle.descripcion, status: @catalog_permits_vehicle.status } }
    end

    assert_redirected_to catalog_permits_vehicle_url(CatalogPermitsVehicle.last)
  end

  test "should show catalog_permits_vehicle" do
    get catalog_permits_vehicle_url(@catalog_permits_vehicle)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_permits_vehicle_url(@catalog_permits_vehicle)
    assert_response :success
  end

  test "should update catalog_permits_vehicle" do
    patch catalog_permits_vehicle_url(@catalog_permits_vehicle), params: { catalog_permits_vehicle: { descripcion: @catalog_permits_vehicle.descripcion, status: @catalog_permits_vehicle.status } }
    assert_redirected_to catalog_permits_vehicle_url(@catalog_permits_vehicle)
  end

  test "should destroy catalog_permits_vehicle" do
    assert_difference('CatalogPermitsVehicle.count', -1) do
      delete catalog_permits_vehicle_url(@catalog_permits_vehicle)
    end

    assert_redirected_to catalog_permits_vehicles_url
  end
end
