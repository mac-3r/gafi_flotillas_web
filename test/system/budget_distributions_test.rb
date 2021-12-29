require "application_system_test_case"

class BudgetDistributionsTest < ApplicationSystemTestCase
  setup do
    @budget_distribution = budget_distributions(:one)
  end

  test "visiting the index" do
    visit budget_distributions_url
    assert_selector "h1", text: "Budget Distributions"
  end

  test "creating a Budget distribution" do
    visit budget_distributions_url
    click_on "New Budget Distribution"

    fill_in "Caja", with: @budget_distribution.caja
    fill_in "Catalog area", with: @budget_distribution.catalog_area_id
    fill_in "Catalog branch", with: @budget_distribution.catalog_branch_id
    fill_in "Catalog brand", with: @budget_distribution.catalog_brand_id
    fill_in "Fecha compra", with: @budget_distribution.fecha_compra
    fill_in "Fecha entrega", with: @budget_distribution.fecha_entrega
    fill_in "Importe", with: @budget_distribution.importe
    fill_in "Muelles", with: @budget_distribution.muelles
    fill_in "Plaqueo", with: @budget_distribution.plaqueo
    fill_in "Reason", with: @budget_distribution.reason_id
    fill_in "Rotulacion", with: @budget_distribution.rotulacion
    fill_in "Seguro", with: @budget_distribution.seguro
    click_on "Create Budget distribution"

    assert_text "Budget distribution was successfully created"
    click_on "Back"
  end

  test "updating a Budget distribution" do
    visit budget_distributions_url
    click_on "Edit", match: :first

    fill_in "Caja", with: @budget_distribution.caja
    fill_in "Catalog area", with: @budget_distribution.catalog_area_id
    fill_in "Catalog branch", with: @budget_distribution.catalog_branch_id
    fill_in "Catalog brand", with: @budget_distribution.catalog_brand_id
    fill_in "Fecha compra", with: @budget_distribution.fecha_compra
    fill_in "Fecha entrega", with: @budget_distribution.fecha_entrega
    fill_in "Importe", with: @budget_distribution.importe
    fill_in "Muelles", with: @budget_distribution.muelles
    fill_in "Plaqueo", with: @budget_distribution.plaqueo
    fill_in "Reason", with: @budget_distribution.reason_id
    fill_in "Rotulacion", with: @budget_distribution.rotulacion
    fill_in "Seguro", with: @budget_distribution.seguro
    click_on "Update Budget distribution"

    assert_text "Budget distribution was successfully updated"
    click_on "Back"
  end

  test "destroying a Budget distribution" do
    visit budget_distributions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Budget distribution was successfully destroyed"
  end
end
