require 'test_helper'

class VehiclePricesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_price = vehicle_prices(:one)
  end

  test "should get index" do
    get vehicle_prices_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_price_url
    assert_response :success
  end

  test "should create vehicle_price" do
    assert_difference('VehiclePrice.count') do
      post vehicle_prices_url, params: { vehicle_price: { catalog_brand_id: @vehicle_price.catalog_brand_id, clave: @vehicle_price.clave, monto: @vehicle_price.monto, status: @vehicle_price.status } }
    end

    assert_redirected_to vehicle_price_url(VehiclePrice.last)
  end

  test "should show vehicle_price" do
    get vehicle_price_url(@vehicle_price)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_price_url(@vehicle_price)
    assert_response :success
  end

  test "should update vehicle_price" do
    patch vehicle_price_url(@vehicle_price), params: { vehicle_price: { catalog_brand_id: @vehicle_price.catalog_brand_id, clave: @vehicle_price.clave, monto: @vehicle_price.monto, status: @vehicle_price.status } }
    assert_redirected_to vehicle_price_url(@vehicle_price)
  end

  test "should destroy vehicle_price" do
    assert_difference('VehiclePrice.count', -1) do
      delete vehicle_price_url(@vehicle_price)
    end

    assert_redirected_to vehicle_prices_url
  end
end
