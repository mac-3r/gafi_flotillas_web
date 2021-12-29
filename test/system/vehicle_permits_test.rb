require "application_system_test_case"

class VehiclePermitsTest < ApplicationSystemTestCase
  setup do
    @vehicle_permit = vehicle_permits(:one)
  end

  test "visiting the index" do
    visit vehicle_permits_url
    assert_selector "h1", text: "Vehicle Permits"
  end

  test "creating a Vehicle permit" do
    visit vehicle_permits_url
    click_on "New Vehicle Permit"

    fill_in "Clave", with: @vehicle_permit.clave
    fill_in "Descripcion", with: @vehicle_permit.descripcion
    check "Status" if @vehicle_permit.status
    click_on "Create Vehicle permit"

    assert_text "Vehicle permit was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle permit" do
    visit vehicle_permits_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @vehicle_permit.clave
    fill_in "Descripcion", with: @vehicle_permit.descripcion
    check "Status" if @vehicle_permit.status
    click_on "Update Vehicle permit"

    assert_text "Vehicle permit was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle permit" do
    visit vehicle_permits_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle permit was successfully destroyed"
  end
end
