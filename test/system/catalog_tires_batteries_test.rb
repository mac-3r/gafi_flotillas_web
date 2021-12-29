require "application_system_test_case"

class CatalogTiresBatteriesTest < ApplicationSystemTestCase
  setup do
    @catalog_tires_battery = catalog_tires_batteries(:one)
  end

  test "visiting the index" do
    visit catalog_tires_batteries_url
    assert_selector "h1", text: "Catalog Tires Batteries"
  end

  test "creating a Catalog tires battery" do
    visit catalog_tires_batteries_url
    click_on "New Catalog Tires Battery"

    fill_in "Catalog brand", with: @catalog_tires_battery.catalog_brand_id
    fill_in "Dls", with: @catalog_tires_battery.dls
    fill_in "Medida", with: @catalog_tires_battery.medida
    fill_in "Modelo", with: @catalog_tires_battery.modelo
    fill_in "Moneda", with: @catalog_tires_battery.moneda
    fill_in "Precio", with: @catalog_tires_battery.precio
    fill_in "Tipo", with: @catalog_tires_battery.tipo
    click_on "Create Catalog tires battery"

    assert_text "Catalog tires battery was successfully created"
    click_on "Back"
  end

  test "updating a Catalog tires battery" do
    visit catalog_tires_batteries_url
    click_on "Edit", match: :first

    fill_in "Catalog brand", with: @catalog_tires_battery.catalog_brand_id
    fill_in "Dls", with: @catalog_tires_battery.dls
    fill_in "Medida", with: @catalog_tires_battery.medida
    fill_in "Modelo", with: @catalog_tires_battery.modelo
    fill_in "Moneda", with: @catalog_tires_battery.moneda
    fill_in "Precio", with: @catalog_tires_battery.precio
    fill_in "Tipo", with: @catalog_tires_battery.tipo
    click_on "Update Catalog tires battery"

    assert_text "Catalog tires battery was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog tires battery" do
    visit catalog_tires_batteries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog tires battery was successfully destroyed"
  end
end
