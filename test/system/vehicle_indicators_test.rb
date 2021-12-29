require "application_system_test_case"

class VehicleIndicatorsTest < ApplicationSystemTestCase
  setup do
    @vehicle_indicator = vehicle_indicators(:one)
  end

  test "visiting the index" do
    visit vehicle_indicators_url
    assert_selector "h1", text: "Vehicle Indicators"
  end

  test "creating a Vehicle indicator" do
    visit vehicle_indicators_url
    click_on "New Vehicle Indicator"

    check "Activacion" if @vehicle_indicator.activacion
    fill_in "Descripcion", with: @vehicle_indicator.descripcion
    fill_in "Dias habiles", with: @vehicle_indicator.dias_habiles
    fill_in "Vehicle type", with: @vehicle_indicator.vehicle_type_id
    click_on "Create Vehicle indicator"

    assert_text "Vehicle indicator was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle indicator" do
    visit vehicle_indicators_url
    click_on "Edit", match: :first

    check "Activacion" if @vehicle_indicator.activacion
    fill_in "Descripcion", with: @vehicle_indicator.descripcion
    fill_in "Dias habiles", with: @vehicle_indicator.dias_habiles
    fill_in "Vehicle type", with: @vehicle_indicator.vehicle_type_id
    click_on "Update Vehicle indicator"

    assert_text "Vehicle indicator was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle indicator" do
    visit vehicle_indicators_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle indicator was successfully destroyed"
  end
end
