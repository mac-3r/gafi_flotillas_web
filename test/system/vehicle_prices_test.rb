require "application_system_test_case"

class VehiclePricesTest < ApplicationSystemTestCase
  setup do
    @vehicle_price = vehicle_prices(:one)
  end

  test "visiting the index" do
    visit vehicle_prices_url
    assert_selector "h1", text: "Vehicle Prices"
  end

  test "creating a Vehicle price" do
    visit vehicle_prices_url
    click_on "New Vehicle Price"

    fill_in "Catalog brand", with: @vehicle_price.catalog_brand_id
    fill_in "Clave", with: @vehicle_price.clave
    fill_in "Monto", with: @vehicle_price.monto
    check "Status" if @vehicle_price.status
    click_on "Create Vehicle price"

    assert_text "Vehicle price was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle price" do
    visit vehicle_prices_url
    click_on "Edit", match: :first

    fill_in "Catalog brand", with: @vehicle_price.catalog_brand_id
    fill_in "Clave", with: @vehicle_price.clave
    fill_in "Monto", with: @vehicle_price.monto
    check "Status" if @vehicle_price.status
    click_on "Update Vehicle price"

    assert_text "Vehicle price was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle price" do
    visit vehicle_prices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle price was successfully destroyed"
  end
end
