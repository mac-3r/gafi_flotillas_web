require "application_system_test_case"

class TicketTireBatteriesTest < ApplicationSystemTestCase
  setup do
    @ticket_tire_battery = ticket_tire_batteries(:one)
  end

  test "visiting the index" do
    visit ticket_tire_batteries_url
    assert_selector "h1", text: "Ticket Tire Batteries"
  end

  test "creating a Ticket tire battery" do
    visit ticket_tire_batteries_url
    click_on "New Ticket Tire Battery"

    fill_in "Cantidad", with: @ticket_tire_battery.cantidad
    fill_in "Dot", with: @ticket_tire_battery.dot
    fill_in "Estatus", with: @ticket_tire_battery.estatus
    fill_in "Fecha", with: @ticket_tire_battery.fecha
    fill_in "Tipo", with: @ticket_tire_battery.tipo
    fill_in "Vehicle", with: @ticket_tire_battery.vehicle_id
    click_on "Create Ticket tire battery"

    assert_text "Ticket tire battery was successfully created"
    click_on "Back"
  end

  test "updating a Ticket tire battery" do
    visit ticket_tire_batteries_url
    click_on "Edit", match: :first

    fill_in "Cantidad", with: @ticket_tire_battery.cantidad
    fill_in "Dot", with: @ticket_tire_battery.dot
    fill_in "Estatus", with: @ticket_tire_battery.estatus
    fill_in "Fecha", with: @ticket_tire_battery.fecha
    fill_in "Tipo", with: @ticket_tire_battery.tipo
    fill_in "Vehicle", with: @ticket_tire_battery.vehicle_id
    click_on "Update Ticket tire battery"

    assert_text "Ticket tire battery was successfully updated"
    click_on "Back"
  end

  test "destroying a Ticket tire battery" do
    visit ticket_tire_batteries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ticket tire battery was successfully destroyed"
  end
end
