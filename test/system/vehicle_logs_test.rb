require "application_system_test_case"

class VehicleLogsTest < ApplicationSystemTestCase
  setup do
    @vehicle_log = vehicle_logs(:one)
  end

  test "visiting the index" do
    visit vehicle_logs_url
    assert_selector "h1", text: "Vehicle Logs"
  end

  test "creating a Vehicle log" do
    visit vehicle_logs_url
    click_on "New Vehicle Log"

    click_on "Create Vehicle log"

    assert_text "Vehicle log was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle log" do
    visit vehicle_logs_url
    click_on "Edit", match: :first

    click_on "Update Vehicle log"

    assert_text "Vehicle log was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle log" do
    visit vehicle_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle log was successfully destroyed"
  end
end
