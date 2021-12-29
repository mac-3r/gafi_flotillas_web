require "application_system_test_case"

class VehicleItemsTest < ApplicationSystemTestCase
  setup do
    @vehicle_item = vehicle_items(:one)
  end

  test "visiting the index" do
    visit vehicle_items_url
    assert_selector "h1", text: "Vehicle Items"
  end

  test "creating a Vehicle item" do
    visit vehicle_items_url
    click_on "New Vehicle Item"

    fill_in "Codigo", with: @vehicle_item.codigo
    fill_in "Date", with: @vehicle_item.date
    fill_in "Estatus", with: @vehicle_item.estatus
    fill_in "Fecha compra", with: @vehicle_item.fecha_compra
    fill_in "Km fin", with: @vehicle_item.km_fin
    fill_in "Km inicio", with: @vehicle_item.km_inicio
    fill_in "String", with: @vehicle_item.string
    fill_in "Tipo", with: @vehicle_item.tipo
    fill_in "Vehicle", with: @vehicle_item.vehicle_id
    click_on "Create Vehicle item"

    assert_text "Vehicle item was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle item" do
    visit vehicle_items_url
    click_on "Edit", match: :first

    fill_in "Codigo", with: @vehicle_item.codigo
    fill_in "Date", with: @vehicle_item.date
    fill_in "Estatus", with: @vehicle_item.estatus
    fill_in "Fecha compra", with: @vehicle_item.fecha_compra
    fill_in "Km fin", with: @vehicle_item.km_fin
    fill_in "Km inicio", with: @vehicle_item.km_inicio
    fill_in "String", with: @vehicle_item.string
    fill_in "Tipo", with: @vehicle_item.tipo
    fill_in "Vehicle", with: @vehicle_item.vehicle_id
    click_on "Update Vehicle item"

    assert_text "Vehicle item was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle item" do
    visit vehicle_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle item was successfully destroyed"
  end
end
