require "application_system_test_case"

class MaintenanceAppointmentsTest < ApplicationSystemTestCase
  setup do
    @maintenance_appointment = maintenance_appointments(:one)
  end

  test "visiting the index" do
    visit maintenance_appointments_url
    assert_selector "h1", text: "Maintenance Appointments"
  end

  test "creating a Maintenance appointment" do
    visit maintenance_appointments_url
    click_on "New Maintenance Appointment"

    fill_in "Catalog workshop", with: @maintenance_appointment.catalog_workshop_id
    fill_in "Fecha cita", with: @maintenance_appointment.fecha_cita
    fill_in "Status", with: @maintenance_appointment.status
    fill_in "Vehicle", with: @maintenance_appointment.vehicle_id
    click_on "Create Maintenance appointment"

    assert_text "Maintenance appointment was successfully created"
    click_on "Back"
  end

  test "updating a Maintenance appointment" do
    visit maintenance_appointments_url
    click_on "Edit", match: :first

    fill_in "Catalog workshop", with: @maintenance_appointment.catalog_workshop_id
    fill_in "Fecha cita", with: @maintenance_appointment.fecha_cita
    fill_in "Status", with: @maintenance_appointment.status
    fill_in "Vehicle", with: @maintenance_appointment.vehicle_id
    click_on "Update Maintenance appointment"

    assert_text "Maintenance appointment was successfully updated"
    click_on "Back"
  end

  test "destroying a Maintenance appointment" do
    visit maintenance_appointments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Maintenance appointment was successfully destroyed"
  end
end
