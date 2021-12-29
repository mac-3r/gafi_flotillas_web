require "application_system_test_case"

class CatalogRepairsTest < ApplicationSystemTestCase
  setup do
    @catalog_repair = catalog_repairs(:one)
  end

  test "visiting the index" do
    visit catalog_repairs_url
    assert_selector "h1", text: "Catalog Repairs"
  end

  test "creating a Catalog repair" do
    visit catalog_repairs_url
    click_on "New Catalog Repair"

    fill_in "Categoria", with: @catalog_repair.categoria
    fill_in "Clave", with: @catalog_repair.clave
    check "Status" if @catalog_repair.status
    fill_in "Subcategoria", with: @catalog_repair.subcategoria
    click_on "Create Catalog repair"

    assert_text "Catalog repair was successfully created"
    click_on "Back"
  end

  test "updating a Catalog repair" do
    visit catalog_repairs_url
    click_on "Edit", match: :first

    fill_in "Categoria", with: @catalog_repair.categoria
    fill_in "Clave", with: @catalog_repair.clave
    check "Status" if @catalog_repair.status
    fill_in "Subcategoria", with: @catalog_repair.subcategoria
    click_on "Update Catalog repair"

    assert_text "Catalog repair was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog repair" do
    visit catalog_repairs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog repair was successfully destroyed"
  end
end
