require "application_system_test_case"

class CatalogPermitsVehiclesTest < ApplicationSystemTestCase
  setup do
    @catalog_permits_vehicle = catalog_permits_vehicles(:one)
  end

  test "visiting the index" do
    visit catalog_permits_vehicles_url
    assert_selector "h1", text: "Catalog Permits Vehicles"
  end

  test "creating a Catalog permits vehicle" do
    visit catalog_permits_vehicles_url
    click_on "New Catalog Permits Vehicle"

    fill_in "Descripcion", with: @catalog_permits_vehicle.descripcion
    check "Status" if @catalog_permits_vehicle.status
    click_on "Create Catalog permits vehicle"

    assert_text "Catalog permits vehicle was successfully created"
    click_on "Back"
  end

  test "updating a Catalog permits vehicle" do
    visit catalog_permits_vehicles_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @catalog_permits_vehicle.descripcion
    check "Status" if @catalog_permits_vehicle.status
    click_on "Update Catalog permits vehicle"

    assert_text "Catalog permits vehicle was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog permits vehicle" do
    visit catalog_permits_vehicles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog permits vehicle was successfully destroyed"
  end
end
