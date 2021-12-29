require 'test_helper'

class PerformTargetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @perform_target = perform_targets(:one)
  end

  test "should get index" do
    get perform_targets_url
    assert_response :success
  end

  test "should get new" do
    get new_perform_target_url
    assert_response :success
  end

  test "should create perform_target" do
    assert_difference('PerformTarget.count') do
      post perform_targets_url, params: { perform_target: { catalog_branch_id: @perform_target.catalog_branch_id, clave: @perform_target.clave, idealperform: @perform_target.idealperform, objperform: @perform_target.objperform, status: @perform_target.status, vehicle_type_id: @perform_target.vehicle_type_id } }
    end

    assert_redirected_to perform_target_url(PerformTarget.last)
  end

  test "should show perform_target" do
    get perform_target_url(@perform_target)
    assert_response :success
  end

  test "should get edit" do
    get edit_perform_target_url(@perform_target)
    assert_response :success
  end

  test "should update perform_target" do
    patch perform_target_url(@perform_target), params: { perform_target: { catalog_branch_id: @perform_target.catalog_branch_id, clave: @perform_target.clave, idealperform: @perform_target.idealperform, objperform: @perform_target.objperform, status: @perform_target.status, vehicle_type_id: @perform_target.vehicle_type_id } }
    assert_redirected_to perform_target_url(@perform_target)
  end

  test "should destroy perform_target" do
    assert_difference('PerformTarget.count', -1) do
      delete perform_target_url(@perform_target)
    end

    assert_redirected_to perform_targets_url
  end
end
