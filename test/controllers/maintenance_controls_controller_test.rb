require 'test_helper'

class MaintenanceControlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maintenance_control = maintenance_controls(:one)
  end

  test "should get index" do
    get maintenance_controls_url
    assert_response :success
  end

  test "should get new" do
    get new_maintenance_control_url
    assert_response :success
  end

  test "should create maintenance_control" do
    assert_difference('MaintenanceControl.count') do
      post maintenance_controls_url, params: { maintenance_control: { año: @maintenance_control.año, catalog_area_id: @maintenance_control.catalog_area_id, catalog_branch_id: @maintenance_control.catalog_branch_id, catalog_repair_id: @maintenance_control.catalog_repair_id, catalog_workshop_id: @maintenance_control.catalog_workshop_id, ciudad: @maintenance_control.ciudad, fecha_factura: @maintenance_control.fecha_factura, importe: @maintenance_control.importe, importe_iva: @maintenance_control.importe_iva, mes_pago: @maintenance_control.mes_pago, observaciones: @maintenance_control.observaciones, responsable_id: @maintenance_control.responsable_id, vehicle_id: @maintenance_control.vehicle_id } }
    end

    assert_redirected_to maintenance_control_url(MaintenanceControl.last)
  end

  test "should show maintenance_control" do
    get maintenance_control_url(@maintenance_control)
    assert_response :success
  end

  test "should get edit" do
    get edit_maintenance_control_url(@maintenance_control)
    assert_response :success
  end

  test "should update maintenance_control" do
    patch maintenance_control_url(@maintenance_control), params: { maintenance_control: { año: @maintenance_control.año, catalog_area_id: @maintenance_control.catalog_area_id, catalog_branch_id: @maintenance_control.catalog_branch_id, catalog_repair_id: @maintenance_control.catalog_repair_id, catalog_workshop_id: @maintenance_control.catalog_workshop_id, ciudad: @maintenance_control.ciudad, fecha_factura: @maintenance_control.fecha_factura, importe: @maintenance_control.importe, importe_iva: @maintenance_control.importe_iva, mes_pago: @maintenance_control.mes_pago, observaciones: @maintenance_control.observaciones, responsable_id: @maintenance_control.responsable_id, vehicle_id: @maintenance_control.vehicle_id } }
    assert_redirected_to maintenance_control_url(@maintenance_control)
  end

  test "should destroy maintenance_control" do
    assert_difference('MaintenanceControl.count', -1) do
      delete maintenance_control_url(@maintenance_control)
    end

    assert_redirected_to maintenance_controls_url
  end
end
