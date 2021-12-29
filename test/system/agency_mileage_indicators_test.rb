require "application_system_test_case"

class AgencyMileageIndicatorsTest < ApplicationSystemTestCase
  setup do
    @agency_mileage_indicator = agency_mileage_indicators(:one)
  end

  test "visiting the index" do
    visit agency_mileage_indicators_url
    assert_selector "h1", text: "Agency Mileage Indicators"
  end

  test "creating a Agency mileage indicator" do
    visit agency_mileage_indicators_url
    click_on "New Agency Mileage Indicator"

    fill_in "Fecha", with: @agency_mileage_indicator.fecha
    fill_in "Km actual", with: @agency_mileage_indicator.km_actual
    fill_in "Tipo", with: @agency_mileage_indicator.tipo
    fill_in "Vehicle", with: @agency_mileage_indicator.vehicle_id
    click_on "Create Agency mileage indicator"

    assert_text "Agency mileage indicator was successfully created"
    click_on "Back"
  end

  test "updating a Agency mileage indicator" do
    visit agency_mileage_indicators_url
    click_on "Edit", match: :first

    fill_in "Fecha", with: @agency_mileage_indicator.fecha
    fill_in "Km actual", with: @agency_mileage_indicator.km_actual
    fill_in "Tipo", with: @agency_mileage_indicator.tipo
    fill_in "Vehicle", with: @agency_mileage_indicator.vehicle_id
    click_on "Update Agency mileage indicator"

    assert_text "Agency mileage indicator was successfully updated"
    click_on "Back"
  end

  test "destroying a Agency mileage indicator" do
    visit agency_mileage_indicators_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Agency mileage indicator was successfully destroyed"
  end
end
