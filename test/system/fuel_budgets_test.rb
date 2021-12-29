require "application_system_test_case"

class FuelBudgetsTest < ApplicationSystemTestCase
  setup do
    @fuel_budget = fuel_budgets(:one)
  end

  test "visiting the index" do
    visit fuel_budgets_url
    assert_selector "h1", text: "Fuel Budgets"
  end

  test "creating a Fuel budget" do
    visit fuel_budgets_url
    click_on "New Fuel Budget"

    fill_in "Clave", with: @fuel_budget.clave
    fill_in "Descripcion", with: @fuel_budget.descripcion
    fill_in "Precio litro", with: @fuel_budget.precio_litro
    click_on "Create Fuel budget"

    assert_text "Fuel budget was successfully created"
    click_on "Back"
  end

  test "updating a Fuel budget" do
    visit fuel_budgets_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @fuel_budget.clave
    fill_in "Descripcion", with: @fuel_budget.descripcion
    fill_in "Precio litro", with: @fuel_budget.precio_litro
    click_on "Update Fuel budget"

    assert_text "Fuel budget was successfully updated"
    click_on "Back"
  end

  test "destroying a Fuel budget" do
    visit fuel_budgets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fuel budget was successfully destroyed"
  end
end
