require "application_system_test_case"

class MaintenanceFrecuenciesTest < ApplicationSystemTestCase
  setup do
    @maintenance_frecuency = maintenance_frecuencies(:one)
  end

  test "visiting the index" do
    visit maintenance_frecuencies_url
    assert_selector "h1", text: "Maintenance Frecuencies"
  end

  test "creating a Maintenance frecuency" do
    visit maintenance_frecuencies_url
    click_on "New Maintenance Frecuency"

    fill_in "Frecuencia", with: @maintenance_frecuency.frecuencia
    fill_in "Mensual recorrido", with: @maintenance_frecuency.mensual_recorrido
    fill_in "Vehicle", with: @maintenance_frecuency.vehicle_id
    click_on "Create Maintenance frecuency"

    assert_text "Maintenance frecuency was successfully created"
    click_on "Back"
  end

  test "updating a Maintenance frecuency" do
    visit maintenance_frecuencies_url
    click_on "Edit", match: :first

    fill_in "Frecuencia", with: @maintenance_frecuency.frecuencia
    fill_in "Mensual recorrido", with: @maintenance_frecuency.mensual_recorrido
    fill_in "Vehicle", with: @maintenance_frecuency.vehicle_id
    click_on "Update Maintenance frecuency"

    assert_text "Maintenance frecuency was successfully updated"
    click_on "Back"
  end

  test "destroying a Maintenance frecuency" do
    visit maintenance_frecuencies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Maintenance frecuency was successfully destroyed"
  end
end
