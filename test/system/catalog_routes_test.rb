require "application_system_test_case"

class CatalogRoutesTest < ApplicationSystemTestCase
  setup do
    @catalog_route = catalog_routes(:one)
  end

  test "visiting the index" do
    visit catalog_routes_url
    assert_selector "h1", text: "Catalog Routes"
  end

  test "creating a Catalog route" do
    visit catalog_routes_url
    click_on "New Catalog Route"

    fill_in "Clave", with: @catalog_route.clave
    fill_in "Descripcion", with: @catalog_route.descripcion
    check "Status" if @catalog_route.status
    click_on "Create Catalog route"

    assert_text "Catalog route was successfully created"
    click_on "Back"
  end

  test "updating a Catalog route" do
    visit catalog_routes_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @catalog_route.clave
    fill_in "Descripcion", with: @catalog_route.descripcion
    check "Status" if @catalog_route.status
    click_on "Update Catalog route"

    assert_text "Catalog route was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog route" do
    visit catalog_routes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog route was successfully destroyed"
  end
end
