require "application_system_test_case"

class MileageIndicatorsTest < ApplicationSystemTestCase
  setup do
    @mileage_indicator = mileage_indicators(:one)
  end

  test "visiting the index" do
    visit mileage_indicators_url
    assert_selector "h1", text: "Mileage Indicators"
  end

  test "creating a Mileage indicator" do
    visit mileage_indicators_url
    click_on "New Mileage Indicator"

    fill_in "Fecha", with: @mileage_indicator.fecha
    fill_in "Km actual", with: @mileage_indicator.km_actual
    fill_in "Vehicle", with: @mileage_indicator.vehicle_id
    click_on "Create Mileage indicator"

    assert_text "Mileage indicator was successfully created"
    click_on "Back"
  end

  test "updating a Mileage indicator" do
    visit mileage_indicators_url
    click_on "Edit", match: :first

    fill_in "Fecha", with: @mileage_indicator.fecha
    fill_in "Km actual", with: @mileage_indicator.km_actual
    fill_in "Vehicle", with: @mileage_indicator.vehicle_id
    click_on "Update Mileage indicator"

    assert_text "Mileage indicator was successfully updated"
    click_on "Back"
  end

  test "destroying a Mileage indicator" do
    visit mileage_indicators_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mileage indicator was successfully destroyed"
  end
end
