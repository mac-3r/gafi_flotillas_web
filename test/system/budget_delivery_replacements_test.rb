require "application_system_test_case"

class BudgetDeliveryReplacementsTest < ApplicationSystemTestCase
  setup do
    @budget_delivery_replacement = budget_delivery_replacements(:one)
  end

  test "visiting the index" do
    visit budget_delivery_replacements_url
    assert_selector "h1", text: "Budget Delivery Replacements"
  end

  test "creating a Budget delivery replacement" do
    visit budget_delivery_replacements_url
    click_on "New Budget Delivery Replacement"

    fill_in "Caja", with: @budget_delivery_replacement.caja
    fill_in "Catalog area", with: @budget_delivery_replacement.catalog_area_id
    fill_in "Catalog branch", with: @budget_delivery_replacement.catalog_branch_id
    fill_in "Catalog brand", with: @budget_delivery_replacement.catalog_brand_id
    fill_in "Fecha compra", with: @budget_delivery_replacement.fecha_compra
    fill_in "Fecha entrega", with: @budget_delivery_replacement.fecha_entrega
    fill_in "Importe", with: @budget_delivery_replacement.importe
    fill_in "Muelle", with: @budget_delivery_replacement.muelle
    fill_in "Plaqueo", with: @budget_delivery_replacement.plaqueo
    fill_in "Reason", with: @budget_delivery_replacement.reason_id
    fill_in "Rotulacion", with: @budget_delivery_replacement.rotulacion
    fill_in "Seguro", with: @budget_delivery_replacement.seguro
    click_on "Create Budget delivery replacement"

    assert_text "Budget delivery replacement was successfully created"
    click_on "Back"
  end

  test "updating a Budget delivery replacement" do
    visit budget_delivery_replacements_url
    click_on "Edit", match: :first

    fill_in "Caja", with: @budget_delivery_replacement.caja
    fill_in "Catalog area", with: @budget_delivery_replacement.catalog_area_id
    fill_in "Catalog branch", with: @budget_delivery_replacement.catalog_branch_id
    fill_in "Catalog brand", with: @budget_delivery_replacement.catalog_brand_id
    fill_in "Fecha compra", with: @budget_delivery_replacement.fecha_compra
    fill_in "Fecha entrega", with: @budget_delivery_replacement.fecha_entrega
    fill_in "Importe", with: @budget_delivery_replacement.importe
    fill_in "Muelle", with: @budget_delivery_replacement.muelle
    fill_in "Plaqueo", with: @budget_delivery_replacement.plaqueo
    fill_in "Reason", with: @budget_delivery_replacement.reason_id
    fill_in "Rotulacion", with: @budget_delivery_replacement.rotulacion
    fill_in "Seguro", with: @budget_delivery_replacement.seguro
    click_on "Update Budget delivery replacement"

    assert_text "Budget delivery replacement was successfully updated"
    click_on "Back"
  end

  test "destroying a Budget delivery replacement" do
    visit budget_delivery_replacements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Budget delivery replacement was successfully destroyed"
  end
end
