require "application_system_test_case"

class BudgetAdministrationsTest < ApplicationSystemTestCase
  setup do
    @budget_administration = budget_administrations(:one)
  end

  test "visiting the index" do
    visit budget_administrations_url
    assert_selector "h1", text: "Budget Administrations"
  end

  test "creating a Budget administration" do
    visit budget_administrations_url
    click_on "New Budget Administration"

    fill_in "Catalog area", with: @budget_administration.catalog_area_id
    fill_in "Catalog branch", with: @budget_administration.catalog_branch_id
    fill_in "Clave", with: @budget_administration.clave
    fill_in "Fecha compra", with: @budget_administration.fecha_compra
    fill_in "Fecha entrega", with: @budget_administration.fecha_entrega
    click_on "Create Budget administration"

    assert_text "Budget administration was successfully created"
    click_on "Back"
  end

  test "updating a Budget administration" do
    visit budget_administrations_url
    click_on "Edit", match: :first

    fill_in "Catalog area", with: @budget_administration.catalog_area_id
    fill_in "Catalog branch", with: @budget_administration.catalog_branch_id
    fill_in "Clave", with: @budget_administration.clave
    fill_in "Fecha compra", with: @budget_administration.fecha_compra
    fill_in "Fecha entrega", with: @budget_administration.fecha_entrega
    click_on "Update Budget administration"

    assert_text "Budget administration was successfully updated"
    click_on "Back"
  end

  test "destroying a Budget administration" do
    visit budget_administrations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Budget administration was successfully destroyed"
  end
end
