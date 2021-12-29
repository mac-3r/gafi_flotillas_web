require 'test_helper'

class VehiclePermitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_permit = vehicle_permits(:one)
  end

  test "should get index" do
    get vehicle_permits_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_permit_url
    assert_response :success
  end

  test "should create vehicle_permit" do
    assert_difference('VehiclePermit.count') do
      post vehicle_permits_url, params: { vehicle_permit: { clave: @vehicle_permit.clave, descripcion: @vehicle_permit.descripcion, status: @vehicle_permit.status } }
    end

    assert_redirected_to vehicle_permit_url(VehiclePermit.last)
  end

  test "should show vehicle_permit" do
    get vehicle_permit_url(@vehicle_permit)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_permit_url(@vehicle_permit)
    assert_response :success
  end

  test "should update vehicle_permit" do
    patch vehicle_permit_url(@vehicle_permit), params: { vehicle_permit: { clave: @vehicle_permit.clave, descripcion: @vehicle_permit.descripcion, status: @vehicle_permit.status,fecha_vigencia: @vehicle_permit.fecha_vigencia } }
    assert_redirected_to vehicle_permit_url(@vehicle_permit)
  end

  test "should destroy vehicle_permit" do
    assert_difference('VehiclePermit.count', -1) do
      delete vehicle_permit_url(@vehicle_permit)
    end

    assert_redirected_to vehicle_permits_url
  end
end
