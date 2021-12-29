require "application_system_test_case"

class VehicleModelsTest < ApplicationSystemTestCase
  setup do
    @vehicle_model = vehicle_models(:one)
  end

  test "visiting the index" do
    visit vehicle_models_url
    assert_selector "h1", text: "Vehicle Models"
  end

  test "creating a Vehicle model" do
    visit vehicle_models_url
    click_on "New Vehicle Model"

    fill_in "Clave", with: @vehicle_model.clave
    fill_in "Descripcion", with: @vehicle_model.descripcion
    check "Status" if @vehicle_model.status
    click_on "Create Vehicle model"

    assert_text "Vehicle model was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle model" do
    visit vehicle_models_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @vehicle_model.clave
    fill_in "Descripcion", with: @vehicle_model.descripcion
    check "Status" if @vehicle_model.status
    click_on "Update Vehicle model"

    assert_text "Vehicle model was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle model" do
    visit vehicle_models_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle model was successfully destroyed"
  end
end
