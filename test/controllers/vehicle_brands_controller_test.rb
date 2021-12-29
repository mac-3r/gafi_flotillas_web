require 'test_helper'

class VehicleBrandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_brand = vehicle_brands(:one)
  end

  test "should get index" do
    get vehicle_brands_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_brand_url
    assert_response :success
  end

  test "should create vehicle_brand" do
    assert_difference('VehicleBrand.count') do
      post vehicle_brands_url, params: { vehicle_brand: { descripcion: @vehicle_brand.descripcion, status: @vehicle_brand.status } }
    end

    assert_redirected_to vehicle_brand_url(VehicleBrand.last)
  end

  test "should show vehicle_brand" do
    get vehicle_brand_url(@vehicle_brand)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_brand_url(@vehicle_brand)
    assert_response :success
  end

  test "should update vehicle_brand" do
    patch vehicle_brand_url(@vehicle_brand), params: { vehicle_brand: { descripcion: @vehicle_brand.descripcion, status: @vehicle_brand.status } }
    assert_redirected_to vehicle_brand_url(@vehicle_brand)
  end

  test "should destroy vehicle_brand" do
    assert_difference('VehicleBrand.count', -1) do
      delete vehicle_brand_url(@vehicle_brand)
    end

    assert_redirected_to vehicle_brands_url
  end
end
