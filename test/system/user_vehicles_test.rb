require "application_system_test_case"

class UserVehiclesTest < ApplicationSystemTestCase
  setup do
    @user_vehicle = user_vehicles(:one)
  end

  test "visiting the index" do
    visit user_vehicles_url
    assert_selector "h1", text: "User Vehicles"
  end

  test "creating a User vehicle" do
    visit user_vehicles_url
    click_on "New User Vehicle"

    fill_in "User", with: @user_vehicle.user_id
    fill_in "Vehicle", with: @user_vehicle.vehicle_id
    click_on "Create User vehicle"

    assert_text "User vehicle was successfully created"
    click_on "Back"
  end

  test "updating a User vehicle" do
    visit user_vehicles_url
    click_on "Edit", match: :first

    fill_in "User", with: @user_vehicle.user_id
    fill_in "Vehicle", with: @user_vehicle.vehicle_id
    click_on "Update User vehicle"

    assert_text "User vehicle was successfully updated"
    click_on "Back"
  end

  test "destroying a User vehicle" do
    visit user_vehicles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User vehicle was successfully destroyed"
  end
end
