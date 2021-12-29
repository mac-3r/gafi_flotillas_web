require "application_system_test_case"

class BudgetSalesReplacementsTest < ApplicationSystemTestCase
  setup do
    @budget_sales_replacement = budget_sales_replacements(:one)
  end

  test "visiting the index" do
    visit budget_sales_replacements_url
    assert_selector "h1", text: "Budget Sales Replacements"
  end

  test "creating a Budget sales replacement" do
    visit budget_sales_replacements_url
    click_on "New Budget Sales Replacement"

    fill_in "Catalog area", with: @budget_sales_replacement.catalog_area_id
    fill_in "Catalog branch", with: @budget_sales_replacement.catalog_branch_id
    fill_in "Catalog brand", with: @budget_sales_replacement.catalog_brand_id
    fill_in "Fecha compra", with: @budget_sales_replacement.fecha_compra
    fill_in "Fecha entrega", with: @budget_sales_replacement.fecha_entrega
    fill_in "Importe", with: @budget_sales_replacement.importe
    fill_in "Plaqueo", with: @budget_sales_replacement.plaqueo
    fill_in "Reason", with: @budget_sales_replacement.reason_id
    fill_in "Seguro", with: @budget_sales_replacement.seguro
    click_on "Create Budget sales replacement"

    assert_text "Budget sales replacement was successfully created"
    click_on "Back"
  end

  test "updating a Budget sales replacement" do
    visit budget_sales_replacements_url
    click_on "Edit", match: :first

    fill_in "Catalog area", with: @budget_sales_replacement.catalog_area_id
    fill_in "Catalog branch", with: @budget_sales_replacement.catalog_branch_id
    fill_in "Catalog brand", with: @budget_sales_replacement.catalog_brand_id
    fill_in "Fecha compra", with: @budget_sales_replacement.fecha_compra
    fill_in "Fecha entrega", with: @budget_sales_replacement.fecha_entrega
    fill_in "Importe", with: @budget_sales_replacement.importe
    fill_in "Plaqueo", with: @budget_sales_replacement.plaqueo
    fill_in "Reason", with: @budget_sales_replacement.reason_id
    fill_in "Seguro", with: @budget_sales_replacement.seguro
    click_on "Update Budget sales replacement"

    assert_text "Budget sales replacement was successfully updated"
    click_on "Back"
  end

  test "destroying a Budget sales replacement" do
    visit budget_sales_replacements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Budget sales replacement was successfully destroyed"
  end
end
