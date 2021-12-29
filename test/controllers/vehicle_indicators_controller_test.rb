require 'test_helper'

class VehicleIndicatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_indicator = vehicle_indicators(:one)
  end

  test "should get index" do
    get vehicle_indicators_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_indicator_url
    assert_response :success
  end

  test "should create vehicle_indicator" do
    assert_difference('VehicleIndicator.count') do
      post vehicle_indicators_url, params: { vehicle_indicator: { activacion: @vehicle_indicator.activacion, descripcion: @vehicle_indicator.descripcion, dias_habiles: @vehicle_indicator.dias_habiles, vehicle_type_id: @vehicle_indicator.vehicle_type_id } }
    end

    assert_redirected_to vehicle_indicator_url(VehicleIndicator.last)
  end

  test "should show vehicle_indicator" do
    get vehicle_indicator_url(@vehicle_indicator)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_indicator_url(@vehicle_indicator)
    assert_response :success
  end

  test "should update vehicle_indicator" do
    patch vehicle_indicator_url(@vehicle_indicator), params: { vehicle_indicator: { activacion: @vehicle_indicator.activacion, descripcion: @vehicle_indicator.descripcion, dias_habiles: @vehicle_indicator.dias_habiles, vehicle_type_id: @vehicle_indicator.vehicle_type_id } }
    assert_redirected_to vehicle_indicator_url(@vehicle_indicator)
  end

  test "should destroy vehicle_indicator" do
    assert_difference('VehicleIndicator.count', -1) do
      delete vehicle_indicator_url(@vehicle_indicator)
    end

    assert_redirected_to vehicle_indicators_url
  end
end
