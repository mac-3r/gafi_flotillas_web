require "application_system_test_case"

class VehicleConsumptionsTest < ApplicationSystemTestCase
  setup do
    @vehicle_consumption = vehicle_consumptions(:one)
  end

  test "visiting the index" do
    visit vehicle_consumptions_url
    assert_selector "h1", text: "Vehicle Consumptions"
  end

  test "creating a Vehicle consumption" do
    visit vehicle_consumptions_url
    click_on "New Vehicle Consumption"

    fill_in "Bomba", with: @vehicle_consumption.bomba
    fill_in "Cantidad", with: @vehicle_consumption.cantidad
    fill_in "Catalog area", with: @vehicle_consumption.catalog_area_id
    fill_in "Catalog brand", with: @vehicle_consumption.catalog_brand_id
    fill_in "Customer", with: @vehicle_consumption.customer_id
    fill_in "Datos", with: @vehicle_consumption.datos
    fill_in "Despacho", with: @vehicle_consumption.despacho
    fill_in "Estacion", with: @vehicle_consumption.estacion
    fill_in "Fecha", with: @vehicle_consumption.fecha
    fill_in "Hora", with: @vehicle_consumption.hora
    fill_in "Monto", with: @vehicle_consumption.monto
    fill_in "Odometro", with: @vehicle_consumption.odometro
    fill_in "Placa", with: @vehicle_consumption.placa
    fill_in "Producto", with: @vehicle_consumption.producto
    fill_in "Recorrido", with: @vehicle_consumption.recorrido
    fill_in "Rendimiento", with: @vehicle_consumption.rendimiento
    fill_in "Responsable", with: @vehicle_consumption.responsable_id
    fill_in "Tarjeta", with: @vehicle_consumption.tarjeta
    fill_in "Vehicle", with: @vehicle_consumption.vehicle_id
    click_on "Create Vehicle consumption"

    assert_text "Vehicle consumption was successfully created"
    click_on "Back"
  end

  test "updating a Vehicle consumption" do
    visit vehicle_consumptions_url
    click_on "Edit", match: :first

    fill_in "Bomba", with: @vehicle_consumption.bomba
    fill_in "Cantidad", with: @vehicle_consumption.cantidad
    fill_in "Catalog area", with: @vehicle_consumption.catalog_area_id
    fill_in "Catalog brand", with: @vehicle_consumption.catalog_brand_id
    fill_in "Customer", with: @vehicle_consumption.customer_id
    fill_in "Datos", with: @vehicle_consumption.datos
    fill_in "Despacho", with: @vehicle_consumption.despacho
    fill_in "Estacion", with: @vehicle_consumption.estacion
    fill_in "Fecha", with: @vehicle_consumption.fecha
    fill_in "Hora", with: @vehicle_consumption.hora
    fill_in "Monto", with: @vehicle_consumption.monto
    fill_in "Odometro", with: @vehicle_consumption.odometro
    fill_in "Placa", with: @vehicle_consumption.placa
    fill_in "Producto", with: @vehicle_consumption.producto
    fill_in "Recorrido", with: @vehicle_consumption.recorrido
    fill_in "Rendimiento", with: @vehicle_consumption.rendimiento
    fill_in "Responsable", with: @vehicle_consumption.responsable_id
    fill_in "Tarjeta", with: @vehicle_consumption.tarjeta
    fill_in "Vehicle", with: @vehicle_consumption.vehicle_id
    click_on "Update Vehicle consumption"

    assert_text "Vehicle consumption was successfully updated"
    click_on "Back"
  end

  test "destroying a Vehicle consumption" do
    visit vehicle_consumptions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vehicle consumption was successfully destroyed"
  end
end
