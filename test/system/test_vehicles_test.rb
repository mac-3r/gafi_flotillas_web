require "application_system_test_case"

class TestVehiclesTest < ApplicationSystemTestCase
  setup do
    @test_vehicle = test_vehicles(:one)
  end

  test "visiting the index" do
    visit test_vehicles_url
    assert_selector "h1", text: "Test Vehicles"
  end

  test "creating a Test vehicle" do
    visit test_vehicles_url
    click_on "New Test Vehicle"

    fill_in "Nombre", with: @test_vehicle.nombre
    fill_in "Numero", with: @test_vehicle.numero
    click_on "Create Test vehicle"

    assert_text "Test vehicle was successfully created"
    click_on "Back"
  end

  test "updating a Test vehicle" do
    visit test_vehicles_url
    click_on "Edit", match: :first

    fill_in "Nombre", with: @test_vehicle.nombre
    fill_in "Numero", with: @test_vehicle.numero
    click_on "Update Test vehicle"

    assert_text "Test vehicle was successfully updated"
    click_on "Back"
  end

  test "destroying a Test vehicle" do
    visit test_vehicles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Test vehicle was successfully destroyed"
  end
end
