require 'test_helper'

class VehicleStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_status = vehicle_statuses(:one)
  end

  test "should get index" do
    get vehicle_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_status_url
    assert_response :success
  end

  test "should create vehicle_status" do
    assert_difference('VehicleStatus.count') do
      post vehicle_statuses_url, params: { vehicle_status: { descripcion: @vehicle_status.descripcion, nombre: @vehicle_status.nombre, status: @vehicle_status.status } }
    end

    assert_redirected_to vehicle_status_url(VehicleStatus.last)
  end

  test "should show vehicle_status" do
    get vehicle_status_url(@vehicle_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_status_url(@vehicle_status)
    assert_response :success
  end

  test "should update vehicle_status" do
    patch vehicle_status_url(@vehicle_status), params: { vehicle_status: { descripcion: @vehicle_status.descripcion, nombre: @vehicle_status.nombre, status: @vehicle_status.status } }
    assert_redirected_to vehicle_status_url(@vehicle_status)
  end

  test "should destroy vehicle_status" do
    assert_difference('VehicleStatus.count', -1) do
      delete vehicle_status_url(@vehicle_status)
    end

    assert_redirected_to vehicle_statuses_url
  end
end
