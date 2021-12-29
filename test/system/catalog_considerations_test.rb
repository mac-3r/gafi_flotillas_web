require "application_system_test_case"

class CatalogConsiderationsTest < ApplicationSystemTestCase
  setup do
    @catalog_consideration = catalog_considerations(:one)
  end

  test "visiting the index" do
    visit catalog_considerations_url
    assert_selector "h1", text: "Catalog Considerations"
  end

  test "creating a Catalog consideration" do
    visit catalog_considerations_url
    click_on "New Catalog Consideration"

    fill_in "Catalog brand", with: @catalog_consideration.catalog_brand_id
    fill_in "Clave", with: @catalog_consideration.clave
    fill_in "Descripcion", with: @catalog_consideration.descripcion
    click_on "Create Catalog consideration"

    assert_text "Catalog consideration was successfully created"
    click_on "Back"
  end

  test "updating a Catalog consideration" do
    visit catalog_considerations_url
    click_on "Edit", match: :first

    fill_in "Catalog brand", with: @catalog_consideration.catalog_brand_id
    fill_in "Clave", with: @catalog_consideration.clave
    fill_in "Descripcion", with: @catalog_consideration.descripcion
    click_on "Update Catalog consideration"

    assert_text "Catalog consideration was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog consideration" do
    visit catalog_considerations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog consideration was successfully destroyed"
  end
end
