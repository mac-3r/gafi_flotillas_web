require 'test_helper'

class TestVehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_vehicle = test_vehicles(:one)
  end

  test "should get index" do
    get test_vehicles_url
    assert_response :success
  end

  test "should get new" do
    get new_test_vehicle_url
    assert_response :success
  end

  test "should create test_vehicle" do
    assert_difference('TestVehicle.count') do
      post test_vehicles_url, params: { test_vehicle: { nombre: @test_vehicle.nombre, numero: @test_vehicle.numero } }
    end

    assert_redirected_to test_vehicle_url(TestVehicle.last)
  end

  test "should show test_vehicle" do
    get test_vehicle_url(@test_vehicle)
    assert_response :success
  end

  test "should get edit" do
    get edit_test_vehicle_url(@test_vehicle)
    assert_response :success
  end

  test "should update test_vehicle" do
    patch test_vehicle_url(@test_vehicle), params: { test_vehicle: { nombre: @test_vehicle.nombre, numero: @test_vehicle.numero } }
    assert_redirected_to test_vehicle_url(@test_vehicle)
  end

  test "should destroy test_vehicle" do
    assert_difference('TestVehicle.count', -1) do
      delete test_vehicle_url(@test_vehicle)
    end

    assert_redirected_to test_vehicles_url
  end
end
