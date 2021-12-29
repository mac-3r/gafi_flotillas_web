require "application_system_test_case"

class DeliveryAddressesTest < ApplicationSystemTestCase
  setup do
    @delivery_address = delivery_addresses(:one)
  end

  test "visiting the index" do
    visit delivery_addresses_url
    assert_selector "h1", text: "Delivery Addresses"
  end

  test "creating a Delivery address" do
    visit delivery_addresses_url
    click_on "New Delivery Address"

    fill_in "Catalog branch", with: @delivery_address.catalog_branch_id
    fill_in "Catalog company", with: @delivery_address.catalog_company_id
    fill_in "Clave", with: @delivery_address.clave
    fill_in "Direccion", with: @delivery_address.direccion
    fill_in "Estatus", with: @delivery_address.estatus
    fill_in "Principal", with: @delivery_address.principal
    click_on "Create Delivery address"

    assert_text "Delivery address was successfully created"
    click_on "Back"
  end

  test "updating a Delivery address" do
    visit delivery_addresses_url
    click_on "Edit", match: :first

    fill_in "Catalog branch", with: @delivery_address.catalog_branch_id
    fill_in "Catalog company", with: @delivery_address.catalog_company_id
    fill_in "Clave", with: @delivery_address.clave
    fill_in "Direccion", with: @delivery_address.direccion
    fill_in "Estatus", with: @delivery_address.estatus
    fill_in "Principal", with: @delivery_address.principal
    click_on "Update Delivery address"

    assert_text "Delivery address was successfully updated"
    click_on "Back"
  end

  test "destroying a Delivery address" do
    visit delivery_addresses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Delivery address was successfully destroyed"
  end
end
