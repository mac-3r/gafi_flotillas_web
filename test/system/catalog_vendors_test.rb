require "application_system_test_case"

class CatalogVendorsTest < ApplicationSystemTestCase
  setup do
    @catalog_vendor = catalog_vendors(:one)
  end

  test "visiting the index" do
    visit catalog_vendors_url
    assert_selector "h1", text: "Catalog Vendors"
  end

  test "creating a Catalog vendor" do
    visit catalog_vendors_url
    click_on "New Catalog Vendor"

    fill_in "Clave", with: @catalog_vendor.clave
    fill_in "Nombre", with: @catalog_vendor.nombre
    click_on "Create Catalog vendor"

    assert_text "Catalog vendor was successfully created"
    click_on "Back"
  end

  test "updating a Catalog vendor" do
    visit catalog_vendors_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @catalog_vendor.clave
    fill_in "Nombre", with: @catalog_vendor.nombre
    click_on "Update Catalog vendor"

    assert_text "Catalog vendor was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog vendor" do
    visit catalog_vendors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog vendor was successfully destroyed"
  end
end
