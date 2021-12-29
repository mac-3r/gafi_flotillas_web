require 'test_helper'

class VehicleLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_log = vehicle_logs(:one)
  end

  test "should get index" do
    get vehicle_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_log_url
    assert_response :success
  end

  test "should create vehicle_log" do
    assert_difference('VehicleLog.count') do
      post vehicle_logs_url, params: { vehicle_log: {  } }
    end

    assert_redirected_to vehicle_log_url(VehicleLog.last)
  end

  test "should show vehicle_log" do
    get vehicle_log_url(@vehicle_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_log_url(@vehicle_log)
    assert_response :success
  end

  test "should update vehicle_log" do
    patch vehicle_log_url(@vehicle_log), params: { vehicle_log: {  } }
    assert_redirected_to vehicle_log_url(@vehicle_log)
  end

  test "should destroy vehicle_log" do
    assert_difference('VehicleLog.count', -1) do
      delete vehicle_log_url(@vehicle_log)
    end

    assert_redirected_to vehicle_logs_url
  end
end
