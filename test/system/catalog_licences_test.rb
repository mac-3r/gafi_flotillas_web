require "application_system_test_case"

class CatalogLicencesTest < ApplicationSystemTestCase
  setup do
    @catalog_licence = catalog_licences(:one)
  end

  test "visiting the index" do
    visit catalog_licences_url
    assert_selector "h1", text: "Catalog Licences"
  end

  test "creating a Catalog licence" do
    visit catalog_licences_url
    click_on "New Catalog Licence"

    fill_in "Clave", with: @catalog_licence.clave
    fill_in "Descripcion", with: @catalog_licence.descripcion
    click_on "Create Catalog licence"

    assert_text "Catalog licence was successfully created"
    click_on "Back"
  end

  test "updating a Catalog licence" do
    visit catalog_licences_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @catalog_licence.clave
    fill_in "Descripcion", with: @catalog_licence.descripcion
    click_on "Update Catalog licence"

    assert_text "Catalog licence was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog licence" do
    visit catalog_licences_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog licence was successfully destroyed"
  end
end
