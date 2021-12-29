require "application_system_test_case"

class PlateStatesTest < ApplicationSystemTestCase
  setup do
    @plate_state = plate_states(:one)
  end

  test "visiting the index" do
    visit plate_states_url
    assert_selector "h1", text: "Plate States"
  end

  test "creating a Plate state" do
    visit plate_states_url
    click_on "New Plate State"

    fill_in "Clave", with: @plate_state.clave
    fill_in "Descripcion", with: @plate_state.descripcion
    check "Status" if @plate_state.status
    click_on "Create Plate state"

    assert_text "Plate state was successfully created"
    click_on "Back"
  end

  test "updating a Plate state" do
    visit plate_states_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @plate_state.clave
    fill_in "Descripcion", with: @plate_state.descripcion
    check "Status" if @plate_state.status
    click_on "Update Plate state"

    assert_text "Plate state was successfully updated"
    click_on "Back"
  end

  test "destroying a Plate state" do
    visit plate_states_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Plate state was successfully destroyed"
  end
end
