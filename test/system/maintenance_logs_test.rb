require "application_system_test_case"

class MaintenanceLogsTest < ApplicationSystemTestCase
  setup do
    @maintenance_log = maintenance_logs(:one)
  end

  test "visiting the index" do
    visit maintenance_logs_url
    assert_selector "h1", text: "Maintenance Logs"
  end

  test "creating a Maintenance log" do
    visit maintenance_logs_url
    click_on "New Maintenance Log"

    fill_in "Catalog brand", with: @maintenance_log.catalog_brand_id
    fill_in "Clave", with: @maintenance_log.clave
    fill_in "Fecha", with: @maintenance_log.fecha
    click_on "Create Maintenance log"

    assert_text "Maintenance log was successfully created"
    click_on "Back"
  end

  test "updating a Maintenance log" do
    visit maintenance_logs_url
    click_on "Edit", match: :first

    fill_in "Catalog brand", with: @maintenance_log.catalog_brand_id
    fill_in "Clave", with: @maintenance_log.clave
    fill_in "Fecha", with: @maintenance_log.fecha
    click_on "Update Maintenance log"

    assert_text "Maintenance log was successfully updated"
    click_on "Back"
  end

  test "destroying a Maintenance log" do
    visit maintenance_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Maintenance log was successfully destroyed"
  end
end
