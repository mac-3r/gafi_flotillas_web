require "application_system_test_case"

class CustomersTest < ApplicationSystemTestCase
  setup do
    @customer = customers(:one)
  end

  test "visiting the index" do
    visit customers_url
    assert_selector "h1", text: "Customers"
  end

  test "creating a Customer" do
    visit customers_url
    click_on "New Customer"

    fill_in "Catalog branch", with: @customer.catalog_branch_id
    fill_in "Catalog company", with: @customer.catalog_company_id
    fill_in "Clave", with: @customer.clave
    fill_in "Estatus", with: @customer.estatus
    click_on "Create Customer"

    assert_text "Customer was successfully created"
    click_on "Back"
  end

  test "updating a Customer" do
    visit customers_url
    click_on "Edit", match: :first

    fill_in "Catalog branch", with: @customer.catalog_branch_id
    fill_in "Catalog company", with: @customer.catalog_company_id
    fill_in "Clave", with: @customer.clave
    fill_in "Estatus", with: @customer.estatus
    click_on "Update Customer"

    assert_text "Customer was successfully updated"
    click_on "Back"
  end

  test "destroying a Customer" do
    visit customers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Customer was successfully destroyed"
  end
end
