require "application_system_test_case"

class VehicleBrandsTest < ApplicationSystemTestCase
  setup do
    @vehicle_brand = vehicle_brands(:one)
  end

  test "visiting the index" do
    visit vehicle_brands_url
    assert_selector "h1", text: "Vehicle Brands"
  end

  test "creating a Vehicle brand" do
    visit vehicle_brands_url
    click_on "New Vehicle Brand"

    fill_in "Descripcion", with: @vehicle_brand.descripcion
    check "Status" if @vehicle_brand.status
    click_on "Create Vehicle brand"

    assert_text "Vehicle brand was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle brand" do
    visit vehicle_brands_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @vehicle_brand.descripcion
    check "Status" if @vehicle_brand.status
    click_on "Update Vehicle brand"

    assert_text "Vehicle brand was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle brand" do
    visit vehicle_brands_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle brand was successfully destroyed"
  end
end
