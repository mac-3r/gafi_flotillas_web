require "application_system_test_case"

class CatalogCompaniesTest < ApplicationSystemTestCase
  setup do
    @catalog_company = catalog_companies(:one)
  end

  test "visiting the index" do
    visit catalog_companies_url
    assert_selector "h1", text: "Catalog Companies"
  end

  test "creating a Catalog company" do
    visit catalog_companies_url
    click_on "New Catalog Company"

    fill_in "Clave", with: @catalog_company.clave
    fill_in "Nombre", with: @catalog_company.nombre
    check "Status" if @catalog_company.status
    click_on "Create Catalog company"

    assert_text "Catalog company was successfully created"
    click_on "Back"
  end

  test "updating a Catalog company" do
    visit catalog_companies_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @catalog_company.clave
    fill_in "Nombre", with: @catalog_company.nombre
    check "Status" if @catalog_company.status
    click_on "Update Catalog company"

    assert_text "Catalog company was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog company" do
    visit catalog_companies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog company was successfully destroyed"
  end
end
