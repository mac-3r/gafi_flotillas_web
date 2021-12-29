require "application_system_test_case"

class VehicleChecklistsTest < ApplicationSystemTestCase
  setup do
    @vehicle_checklist = vehicle_checklists(:one)
  end

  test "visiting the index" do
    visit vehicle_checklists_url
    assert_selector "h1", text: "Vehicle Checklists"
  end

  test "creating a Vehicle checklist" do
    visit vehicle_checklists_url
    click_on "New Vehicle Checklist"

    fill_in "Clasificacionvehiculo", with: @vehicle_checklist.clasificacionvehiculo
    fill_in "Conceptovehiculo", with: @vehicle_checklist.conceptovehiculo
    fill_in "Vehicle types", with: @vehicle_checklist.vehicle_types_id
    click_on "Create Vehicle checklist"

    assert_text "Vehicle checklist was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle checklist" do
    visit vehicle_checklists_url
    click_on "Edit", match: :first

    fill_in "Clasificacionvehiculo", with: @vehicle_checklist.clasificacionvehiculo
    fill_in "Conceptovehiculo", with: @vehicle_checklist.conceptovehiculo
    fill_in "Vehicle types", with: @vehicle_checklist.vehicle_types_id
    click_on "Update Vehicle checklist"

    assert_text "Vehicle checklist was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle checklist" do
    visit vehicle_checklists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle checklist was successfully destroyed"
  end
end
