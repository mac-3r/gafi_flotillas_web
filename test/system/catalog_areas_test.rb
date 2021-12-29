require "application_system_test_case"

class CatalogAreasTest < ApplicationSystemTestCase
  setup do
    @catalog_area = catalog_areas(:one)
  end

  test "visiting the index" do
    visit catalog_areas_url
    assert_selector "h1", text: "Catalog Areas"
  end

  test "creating a Catalog area" do
    visit catalog_areas_url
    click_on "New Catalog Area"

    fill_in "Descripcion", with: @catalog_area.descripcion
    check "Status" if @catalog_area.status
    click_on "Create Catalog area"

    assert_text "Catalog area was successfully created"
    click_on "Back"
  end

  test "updating a Catalog area" do
    visit catalog_areas_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @catalog_area.descripcion
    check "Status" if @catalog_area.status
    click_on "Update Catalog area"

    assert_text "Catalog area was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog area" do
    visit catalog_areas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog area was successfully destroyed"
  end
end
