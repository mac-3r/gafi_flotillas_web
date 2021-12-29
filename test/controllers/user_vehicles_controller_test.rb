require 'test_helper'

class UserVehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_vehicle = user_vehicles(:one)
  end

  test "should get index" do
    get user_vehicles_url
    assert_response :success
  end

  test "should get new" do
    get new_user_vehicle_url
    assert_response :success
  end

  test "should create user_vehicle" do
    assert_difference('UserVehicle.count') do
      post user_vehicles_url, params: { user_vehicle: { user_id: @user_vehicle.user_id, vehicle_id: @user_vehicle.vehicle_id } }
    end

    assert_redirected_to user_vehicle_url(UserVehicle.last)
  end

  test "should show user_vehicle" do
    get user_vehicle_url(@user_vehicle)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_vehicle_url(@user_vehicle)
    assert_response :success
  end

  test "should update user_vehicle" do
    patch user_vehicle_url(@user_vehicle), params: { user_vehicle: { user_id: @user_vehicle.user_id, vehicle_id: @user_vehicle.vehicle_id } }
    assert_redirected_to user_vehicle_url(@user_vehicle)
  end

  test "should destroy user_vehicle" do
    assert_difference('UserVehicle.count', -1) do
      delete user_vehicle_url(@user_vehicle)
    end

    assert_redirected_to user_vehicles_url
  end
end
