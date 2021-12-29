require 'test_helper'

class VehicleChecklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_checklist = vehicle_checklists(:one)
  end

  test "should get index" do
    get vehicle_checklists_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_checklist_url
    assert_response :success
  end

  test "should create vehicle_checklist" do
    assert_difference('VehicleChecklist.count') do
      post vehicle_checklists_url, params: { vehicle_checklist: { clasificacionvehiculo: @vehicle_checklist.clasificacionvehiculo, conceptovehiculo: @vehicle_checklist.conceptovehiculo, vehicle_types_id: @vehicle_checklist.vehicle_types_id } }
    end

    assert_redirected_to vehicle_checklist_url(VehicleChecklist.last)
  end

  test "should show vehicle_checklist" do
    get vehicle_checklist_url(@vehicle_checklist)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_checklist_url(@vehicle_checklist)
    assert_response :success
  end

  test "should update vehicle_checklist" do
    patch vehicle_checklist_url(@vehicle_checklist), params: { vehicle_checklist: { clasificacionvehiculo: @vehicle_checklist.clasificacionvehiculo, conceptovehiculo: @vehicle_checklist.conceptovehiculo, vehicle_types_id: @vehicle_checklist.vehicle_types_id } }
    assert_redirected_to vehicle_checklist_url(@vehicle_checklist)
  end

  test "should destroy vehicle_checklist" do
    assert_difference('VehicleChecklist.count', -1) do
      delete vehicle_checklist_url(@vehicle_checklist)
    end

    assert_redirected_to vehicle_checklists_url
  end
end
