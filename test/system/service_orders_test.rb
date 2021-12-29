require "application_system_test_case"

class ServiceOrdersTest < ApplicationSystemTestCase
  setup do
    @service_order = service_orders(:one)
  end

  test "visiting the index" do
    visit service_orders_url
    assert_selector "h1", text: "Service Orders"
  end

  test "creating a Service order" do
    visit service_orders_url
    click_on "New Service Order"

    fill_in "Descripcion", with: @service_order.descripcion
    fill_in "Estatus", with: @service_order.estatus
    fill_in "Fecha entrada", with: @service_order.fecha_entrada
    fill_in "Fecha salida", with: @service_order.fecha_salida
    fill_in "Maintenance appointment", with: @service_order.maintenance_appointment_id
    fill_in "Maintenance program", with: @service_order.maintenance_program_id
    fill_in "N orden", with: @service_order.n_orden
    click_on "Create Service order"

    assert_text "Service order was successfully created"
    click_on "Back"
  end

  test "updating a Service order" do
    visit service_orders_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @service_order.descripcion
    fill_in "Estatus", with: @service_order.estatus
    fill_in "Fecha entrada", with: @service_order.fecha_entrada
    fill_in "Fecha salida", with: @service_order.fecha_salida
    fill_in "Maintenance appointment", with: @service_order.maintenance_appointment_id
    fill_in "Maintenance program", with: @service_order.maintenance_program_id
    fill_in "N orden", with: @service_order.n_orden
    click_on "Update Service order"

    assert_text "Service order was successfully updated"
    click_on "Back"
  end

  test "destroying a Service order" do
    visit service_orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Service order was successfully destroyed"
  end
end
