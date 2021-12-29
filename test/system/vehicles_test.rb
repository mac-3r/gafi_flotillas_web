require "application_system_test_case"

class VehiclesTest < ApplicationSystemTestCase
  setup do
    @vehicle = vehicles(:one)
  end

  test "visiting the index" do
    visit vehicles_url
    assert_selector "h1", text: "Vehicles"
  end

  test "creating a Vehicle" do
    visit vehicles_url
    click_on "New Vehicle"

    fill_in "Billed company", with: @vehicle.billed_company_id
    fill_in "Branch office", with: @vehicle.branch_office_id
    fill_in "Catalog company", with: @vehicle.catalog_company_id
    fill_in "Catalog route", with: @vehicle.catalog_route_id
    fill_in "Clave", with: @vehicle.clave
    fill_in "Cost center", with: @vehicle.cost_center_id
    fill_in "Fecha compra", with: @vehicle.fecha_compra
    fill_in "Inciso", with: @vehicle.inciso
    fill_in "Insurance beneficiary", with: @vehicle.insurance_beneficiary_id
    fill_in "Litros autorizados", with: @vehicle.litros_autorizados
    fill_in "Numero economico", with: @vehicle.numero_economico
    fill_in "Numero factura", with: @vehicle.numero_factura
    fill_in "Numero factura adapt", with: @vehicle.numero_factura_adapt
    fill_in "Numero motor", with: @vehicle.numero_motor
    fill_in "Numero placa", with: @vehicle.numero_placa
    fill_in "Numero poliza", with: @vehicle.numero_poliza
    fill_in "Numero serie", with: @vehicle.numero_serie
    fill_in "Numero serie adapt", with: @vehicle.numero_serie_adapt
    fill_in "Permiso ambiental", with: @vehicle.permiso_ambiental
    fill_in "Permiso federal carga", with: @vehicle.permiso_federal_carga
    fill_in "Permiso fisico mecanico", with: @vehicle.permiso_fisico_mecanico
    fill_in "Plate state", with: @vehicle.plate_state_id
    fill_in "Policy coverage", with: @vehicle.policy_coverage_id
    fill_in "Responsable", with: @vehicle.responsable_id
    check "Status" if @vehicle.status
    fill_in "Transmision", with: @vehicle.transmision
    fill_in "Valor adapt", with: @vehicle.valor_adapt
    fill_in "Valor compra", with: @vehicle.valor_compra
    fill_in "Vehicle brand", with: @vehicle.vehicle_brand_id
    fill_in "Vehicle model", with: @vehicle.vehicle_model_id
    fill_in "Vehicle status", with: @vehicle.vehicle_status_id
    fill_in "Vehicle type", with: @vehicle.vehicle_type_id
    click_on "Create Vehicle"

    assert_text "Vehicle was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle" do
    visit vehicles_url
    click_on "Edit", match: :first

    fill_in "Billed company", with: @vehicle.billed_company_id
    fill_in "Branch office", with: @vehicle.branch_office_id
    fill_in "Catalog company", with: @vehicle.catalog_company_id
    fill_in "Catalog route", with: @vehicle.catalog_route_id
    fill_in "Clave", with: @vehicle.clave
    fill_in "Cost center", with: @vehicle.cost_center_id
    fill_in "Fecha compra", with: @vehicle.fecha_compra
    fill_in "Inciso", with: @vehicle.inciso
    fill_in "Insurance beneficiary", with: @vehicle.insurance_beneficiary_id
    fill_in "Litros autorizados", with: @vehicle.litros_autorizados
    fill_in "Numero economico", with: @vehicle.numero_economico
    fill_in "Numero factura", with: @vehicle.numero_factura
    fill_in "Numero factura adapt", with: @vehicle.numero_factura_adapt
    fill_in "Numero motor", with: @vehicle.numero_motor
    fill_in "Numero placa", with: @vehicle.numero_placa
    fill_in "Numero poliza", with: @vehicle.numero_poliza
    fill_in "Numero serie", with: @vehicle.numero_serie
    fill_in "Numero serie adapt", with: @vehicle.numero_serie_adapt
    fill_in "Permiso ambiental", with: @vehicle.permiso_ambiental
    fill_in "Permiso federal carga", with: @vehicle.permiso_federal_carga
    fill_in "Permiso fisico mecanico", with: @vehicle.permiso_fisico_mecanico
    fill_in "Plate state", with: @vehicle.plate_state_id
    fill_in "Policy coverage", with: @vehicle.policy_coverage_id
    fill_in "Responsable", with: @vehicle.responsable_id
    check "Status" if @vehicle.status
    fill_in "Transmision", with: @vehicle.transmision
    fill_in "Valor adapt", with: @vehicle.valor_adapt
    fill_in "Valor compra", with: @vehicle.valor_compra
    fill_in "Vehicle brand", with: @vehicle.vehicle_brand_id
    fill_in "Vehicle model", with: @vehicle.vehicle_model_id
    fill_in "Vehicle status", with: @vehicle.vehicle_status_id
    fill_in "Vehicle type", with: @vehicle.vehicle_type_id
    click_on "Update Vehicle"

    assert_text "Vehicle was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle" do
    visit vehicles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle was successfully destroyed"
  end
end
