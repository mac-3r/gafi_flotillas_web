require 'test_helper'

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle = vehicles(:one)
  end

  test "should get index" do
    get vehicles_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_url
    assert_response :success
  end

  test "should create vehicle" do
    assert_difference('Vehicle.count') do
      post vehicles_url, params: { vehicle: { billed_company_id: @vehicle.billed_company_id, branch_office_id: @vehicle.branch_office_id, catalog_company_id: @vehicle.catalog_company_id, catalog_route_id: @vehicle.catalog_route_id, clave: @vehicle.clave, cost_center_id: @vehicle.cost_center_id, fecha_compra: @vehicle.fecha_compra, inciso: @vehicle.inciso, insurance_beneficiary_id: @vehicle.insurance_beneficiary_id, litros_autorizados: @vehicle.litros_autorizados, numero_economico: @vehicle.numero_economico, numero_factura: @vehicle.numero_factura, numero_factura_adapt: @vehicle.numero_factura_adapt, numero_motor: @vehicle.numero_motor, numero_placa: @vehicle.numero_placa, numero_poliza: @vehicle.numero_poliza, numero_serie: @vehicle.numero_serie, numero_serie_adapt: @vehicle.numero_serie_adapt, permiso_ambiental: @vehicle.permiso_ambiental, permiso_federal_carga: @vehicle.permiso_federal_carga, permiso_fisico_mecanico: @vehicle.permiso_fisico_mecanico, plate_state_id: @vehicle.plate_state_id, policy_coverage_id: @vehicle.policy_coverage_id, responsable_id: @vehicle.responsable_id, status: @vehicle.status, transmision: @vehicle.transmision, valor_adapt: @vehicle.valor_adapt, valor_compra: @vehicle.valor_compra, vehicle_brand_id: @vehicle.vehicle_brand_id, vehicle_model_id: @vehicle.vehicle_model_id, vehicle_status_id: @vehicle.vehicle_status_id, vehicle_type_id: @vehicle.vehicle_type_id } }
    end

    assert_redirected_to vehicle_url(Vehicle.last)
  end

  test "should show vehicle" do
    get vehicle_url(@vehicle)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_url(@vehicle)
    assert_response :success
  end

  test "should update vehicle" do
    patch vehicle_url(@vehicle), params: { vehicle: { billed_company_id: @vehicle.billed_company_id, branch_office_id: @vehicle.branch_office_id, catalog_company_id: @vehicle.catalog_company_id, catalog_route_id: @vehicle.catalog_route_id, clave: @vehicle.clave, cost_center_id: @vehicle.cost_center_id, fecha_compra: @vehicle.fecha_compra, inciso: @vehicle.inciso, insurance_beneficiary_id: @vehicle.insurance_beneficiary_id, litros_autorizados: @vehicle.litros_autorizados, numero_economico: @vehicle.numero_economico, numero_factura: @vehicle.numero_factura, numero_factura_adapt: @vehicle.numero_factura_adapt, numero_motor: @vehicle.numero_motor, numero_placa: @vehicle.numero_placa, numero_poliza: @vehicle.numero_poliza, numero_serie: @vehicle.numero_serie, numero_serie_adapt: @vehicle.numero_serie_adapt, permiso_ambiental: @vehicle.permiso_ambiental, permiso_federal_carga: @vehicle.permiso_federal_carga, permiso_fisico_mecanico: @vehicle.permiso_fisico_mecanico, plate_state_id: @vehicle.plate_state_id, policy_coverage_id: @vehicle.policy_coverage_id, responsable_id: @vehicle.responsable_id, status: @vehicle.status, transmision: @vehicle.transmision, valor_adapt: @vehicle.valor_adapt, valor_compra: @vehicle.valor_compra, vehicle_brand_id: @vehicle.vehicle_brand_id, vehicle_model_id: @vehicle.vehicle_model_id, vehicle_status_id: @vehicle.vehicle_status_id, vehicle_type_id: @vehicle.vehicle_type_id } }
    assert_redirected_to vehicle_url(@vehicle)
  end

  test "should destroy vehicle" do
    assert_difference('Vehicle.count', -1) do
      delete vehicle_url(@vehicle)
    end

    assert_redirected_to vehicles_url
  end
end
