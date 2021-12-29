require 'test_helper'

class MaintenanceLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maintenance_log = maintenance_logs(:one)
  end

  test "should get index" do
    get maintenance_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_maintenance_log_url
    assert_response :success
  end

  test "should create maintenance_log" do
    assert_difference('MaintenanceLog.count') do
      post maintenance_logs_url, params: { maintenance_log: { catalog_brand_id: @maintenance_log.catalog_brand_id, clave: @maintenance_log.clave, fecha: @maintenance_log.fecha } }
    end

    assert_redirected_to maintenance_log_url(MaintenanceLog.last)
  end

  test "should show maintenance_log" do
    get maintenance_log_url(@maintenance_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_maintenance_log_url(@maintenance_log)
    assert_response :success
  end

  test "should update maintenance_log" do
    patch maintenance_log_url(@maintenance_log), params: { maintenance_log: { catalog_brand_id: @maintenance_log.catalog_brand_id, clave: @maintenance_log.clave, fecha: @maintenance_log.fecha } }
    assert_redirected_to maintenance_log_url(@maintenance_log)
  end

  test "should destroy maintenance_log" do
    assert_difference('MaintenanceLog.count', -1) do
      delete maintenance_log_url(@maintenance_log)
    end

    assert_redirected_to maintenance_logs_url
  end
end
