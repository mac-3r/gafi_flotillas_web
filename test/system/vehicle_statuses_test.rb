require "application_system_test_case"

class VehicleStatusesTest < ApplicationSystemTestCase
  setup do
    @vehicle_status = vehicle_statuses(:one)
  end

  test "visiting the index" do
    visit vehicle_statuses_url
    assert_selector "h1", text: "Vehicle Statuses"
  end

  test "creating a Vehicle status" do
    visit vehicle_statuses_url
    click_on "New Vehicle Status"

    fill_in "Descripcion", with: @vehicle_status.descripcion
    fill_in "Nombre", with: @vehicle_status.nombre
    check "Status" if @vehicle_status.status
    click_on "Create Vehicle status"

    assert_text "Vehicle status was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle status" do
    visit vehicle_statuses_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @vehicle_status.descripcion
    fill_in "Nombre", with: @vehicle_status.nombre
    check "Status" if @vehicle_status.status
    click_on "Update Vehicle status"

    assert_text "Vehicle status was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle status" do
    visit vehicle_statuses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle status was successfully destroyed"
  end
end
