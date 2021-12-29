require "application_system_test_case"

class PurchaseOrdersTest < ApplicationSystemTestCase
  setup do
    @purchase_order = purchase_orders(:one)
  end

  test "visiting the index" do
    visit purchase_orders_url
    assert_selector "h1", text: "Purchase Orders"
  end

  test "creating a Purchase order" do
    visit purchase_orders_url
    click_on "New Purchase Order"

    fill_in "Catalog area", with: @purchase_order.catalog_area_id
    fill_in "Catalog branch", with: @purchase_order.catalog_branch_id
    fill_in "Cost center", with: @purchase_order.cost_center_id
    fill_in "Fecha", with: @purchase_order.fecha
    fill_in "Monto", with: @purchase_order.monto
    fill_in "Observaciones", with: @purchase_order.observaciones
    fill_in "Usuario", with: @purchase_order.usuario
    fill_in "Vehicle brand", with: @purchase_order.vehicle_brand_id
    fill_in "Vehicle type", with: @purchase_order.vehicle_type_id
    click_on "Create Purchase order"

    assert_text "Purchase order was successfully created"
    click_on "Back"
  end

  test "updating a Purchase order" do
    visit purchase_orders_url
    click_on "Edit", match: :first

    fill_in "Catalog area", with: @purchase_order.catalog_area_id
    fill_in "Catalog branch", with: @purchase_order.catalog_branch_id
    fill_in "Cost center", with: @purchase_order.cost_center_id
    fill_in "Fecha", with: @purchase_order.fecha
    fill_in "Monto", with: @purchase_order.monto
    fill_in "Observaciones", with: @purchase_order.observaciones
    fill_in "Usuario", with: @purchase_order.usuario
    fill_in "Vehicle brand", with: @purchase_order.vehicle_brand_id
    fill_in "Vehicle type", with: @purchase_order.vehicle_type_id
    click_on "Update Purchase order"

    assert_text "Purchase order was successfully updated"
    click_on "Back"
  end

  test "destroying a Purchase order" do
    visit purchase_orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Purchase order was successfully destroyed"
  end
end
