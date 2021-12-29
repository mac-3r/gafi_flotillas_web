require "application_system_test_case"

class ExpenseVehicleTypesTest < ApplicationSystemTestCase
  setup do
    @expense_vehicle_type = expense_vehicle_types(:one)
  end

  test "visiting the index" do
    visit expense_vehicle_types_url
    assert_selector "h1", text: "Expense Vehicle Types"
  end

  test "creating a Expense vehicle type" do
    visit expense_vehicle_types_url
    click_on "New Expense Vehicle Type"

    fill_in "Catalog branch", with: @expense_vehicle_type.catalog_branch_id
    fill_in "Catalog brand", with: @expense_vehicle_type.catalog_brand_id
    fill_in "Clave", with: @expense_vehicle_type.clave
    fill_in "Gasto", with: @expense_vehicle_type.gasto
    click_on "Create Expense vehicle type"

    assert_text "Expense vehicle type was successfully created"
    click_on "Back"
  end

  test "updating a Expense vehicle type" do
    visit expense_vehicle_types_url
    click_on "Edit", match: :first

    fill_in "Catalog branch", with: @expense_vehicle_type.catalog_branch_id
    fill_in "Catalog brand", with: @expense_vehicle_type.catalog_brand_id
    fill_in "Clave", with: @expense_vehicle_type.clave
    fill_in "Gasto", with: @expense_vehicle_type.gasto
    click_on "Update Expense vehicle type"

    assert_text "Expense vehicle type was successfully updated"
    click_on "Back"
  end

  test "destroying a Expense vehicle type" do
    visit expense_vehicle_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Expense vehicle type was successfully destroyed"
  end
end
