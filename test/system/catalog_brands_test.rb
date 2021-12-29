require "application_system_test_case"

class CatalogBrandsTest < ApplicationSystemTestCase
  setup do
    @catalog_brand = catalog_brands(:one)
  end

  test "visiting the index" do
    visit catalog_brands_url
    assert_selector "h1", text: "Catalog Brands"
  end

  test "creating a Catalog brand" do
    visit catalog_brands_url
    click_on "New Catalog Brand"

    fill_in "Clave", with: @catalog_brand.clave
    fill_in "Descripcion", with: @catalog_brand.descripcion
    check "Status" if @catalog_brand.status
    click_on "Create Catalog brand"

    assert_text "Catalog brand was successfully created"
    click_on "Back"
  end

  test "updating a Catalog brand" do
    visit catalog_brands_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @catalog_brand.clave
    fill_in "Descripcion", with: @catalog_brand.descripcion
    check "Status" if @catalog_brand.status
    click_on "Update Catalog brand"

    assert_text "Catalog brand was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog brand" do
    visit catalog_brands_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog brand was successfully destroyed"
  end
end
