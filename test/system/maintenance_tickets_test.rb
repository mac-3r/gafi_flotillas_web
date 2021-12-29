require "application_system_test_case"

class MaintenanceTicketsTest < ApplicationSystemTestCase
  setup do
    @maintenance_ticket = maintenance_tickets(:one)
  end

  test "visiting the index" do
    visit maintenance_tickets_url
    assert_selector "h1", text: "Maintenance Tickets"
  end

  test "creating a Maintenance ticket" do
    visit maintenance_tickets_url
    click_on "New Maintenance Ticket"

    fill_in "Descripcion", with: @maintenance_ticket.descripcion
    fill_in "Estatus", with: @maintenance_ticket.estatus
    fill_in "Fecha alta", with: @maintenance_ticket.fecha_alta
    fill_in "Vehicle", with: @maintenance_ticket.vehicle_id
    click_on "Create Maintenance ticket"

    assert_text "Maintenance ticket was successfully created"
    click_on "Back"
  end

  test "updating a Maintenance ticket" do
    visit maintenance_tickets_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @maintenance_ticket.descripcion
    fill_in "Estatus", with: @maintenance_ticket.estatus
    fill_in "Fecha alta", with: @maintenance_ticket.fecha_alta
    fill_in "Vehicle", with: @maintenance_ticket.vehicle_id
    click_on "Update Maintenance ticket"

    assert_text "Maintenance ticket was successfully updated"
    click_on "Back"
  end

  test "destroying a Maintenance ticket" do
    visit maintenance_tickets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Maintenance ticket was successfully destroyed"
  end
end
