require "application_system_test_case"

class MaintenanceControlsTest < ApplicationSystemTestCase
  setup do
    @maintenance_control = maintenance_controls(:one)
  end

  test "visiting the index" do
    visit maintenance_controls_url
    assert_selector "h1", text: "Maintenance Controls"
  end

  test "creating a Maintenance control" do
    visit maintenance_controls_url
    click_on "New Maintenance Control"

    fill_in "Año", with: @maintenance_control.año
    fill_in "Catalog area", with: @maintenance_control.catalog_area_id
    fill_in "Catalog branch", with: @maintenance_control.catalog_branch_id
    fill_in "Catalog repair", with: @maintenance_control.catalog_repair_id
    fill_in "Catalog workshop", with: @maintenance_control.catalog_workshop_id
    fill_in "Ciudad", with: @maintenance_control.ciudad
    fill_in "Fecha factura", with: @maintenance_control.fecha_factura
    fill_in "Importe", with: @maintenance_control.importe
    fill_in "Importe iva", with: @maintenance_control.importe_iva
    fill_in "Mes pago", with: @maintenance_control.mes_pago
    fill_in "Observaciones", with: @maintenance_control.observaciones
    fill_in "Responsable", with: @maintenance_control.responsable_id
    fill_in "Vehicle", with: @maintenance_control.vehicle_id
    click_on "Create Maintenance control"

    assert_text "Maintenance control was successfully created"
    click_on "Back"
  end

  test "updating a Maintenance control" do
    visit maintenance_controls_url
    click_on "Edit", match: :first

    fill_in "Año", with: @maintenance_control.año
    fill_in "Catalog area", with: @maintenance_control.catalog_area_id
    fill_in "Catalog branch", with: @maintenance_control.catalog_branch_id
    fill_in "Catalog repair", with: @maintenance_control.catalog_repair_id
    fill_in "Catalog workshop", with: @maintenance_control.catalog_workshop_id
    fill_in "Ciudad", with: @maintenance_control.ciudad
    fill_in "Fecha factura", with: @maintenance_control.fecha_factura
    fill_in "Importe", with: @maintenance_control.importe
    fill_in "Importe iva", with: @maintenance_control.importe_iva
    fill_in "Mes pago", with: @maintenance_control.mes_pago
    fill_in "Observaciones", with: @maintenance_control.observaciones
    fill_in "Responsable", with: @maintenance_control.responsable_id
    fill_in "Vehicle", with: @maintenance_control.vehicle_id
    click_on "Update Maintenance control"

    assert_text "Maintenance control was successfully updated"
    click_on "Back"
  end

  test "destroying a Maintenance control" do
    visit maintenance_controls_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Maintenance control was successfully destroyed"
  end
end
