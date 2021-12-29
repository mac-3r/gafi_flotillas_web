require "application_system_test_case"

class AccumulatedFuelsTest < ApplicationSystemTestCase
  setup do
    @accumulated_fuel = accumulated_fuels(:one)
  end

  test "visiting the index" do
    visit accumulated_fuels_url
    assert_selector "h1", text: "Accumulated Fuels"
  end

  test "creating a Accumulated fuel" do
    visit accumulated_fuels_url
    click_on "New Accumulated Fuel"

    fill_in "Area", with: @accumulated_fuel.area
    fill_in "Cedis", with: @accumulated_fuel.cedis
    fill_in "Fecha carga", with: @accumulated_fuel.fecha_carga
    fill_in "Fecha fin", with: @accumulated_fuel.fecha_fin
    fill_in "Fecha inicio", with: @accumulated_fuel.fecha_inicio
    fill_in "Gasto", with: @accumulated_fuel.gasto
    fill_in "Importe base", with: @accumulated_fuel.importe_base
    fill_in "Importe total", with: @accumulated_fuel.importe_total
    fill_in "Km actual", with: @accumulated_fuel.km_actual
    fill_in "Km inicial", with: @accumulated_fuel.km_inicial
    fill_in "Km recorrido", with: @accumulated_fuel.km_recorrido
    fill_in "Linea", with: @accumulated_fuel.linea
    fill_in "Litros consumidos", with: @accumulated_fuel.litros_consumidos
    fill_in "N factura", with: @accumulated_fuel.n_factura
    fill_in "No economico", with: @accumulated_fuel.no_economico
    fill_in "Presupuesto", with: @accumulated_fuel.presupuesto
    fill_in "Responsable", with: @accumulated_fuel.responsable
    fill_in "Tipo vehicu", with: @accumulated_fuel.tipo_vehicu
    click_on "Create Accumulated fuel"

    assert_text "Accumulated fuel was successfully created"
    click_on "Back"
  end

  test "updating a Accumulated fuel" do
    visit accumulated_fuels_url
    click_on "Edit", match: :first

    fill_in "Area", with: @accumulated_fuel.area
    fill_in "Cedis", with: @accumulated_fuel.cedis
    fill_in "Fecha carga", with: @accumulated_fuel.fecha_carga
    fill_in "Fecha fin", with: @accumulated_fuel.fecha_fin
    fill_in "Fecha inicio", with: @accumulated_fuel.fecha_inicio
    fill_in "Gasto", with: @accumulated_fuel.gasto
    fill_in "Importe base", with: @accumulated_fuel.importe_base
    fill_in "Importe total", with: @accumulated_fuel.importe_total
    fill_in "Km actual", with: @accumulated_fuel.km_actual
    fill_in "Km inicial", with: @accumulated_fuel.km_inicial
    fill_in "Km recorrido", with: @accumulated_fuel.km_recorrido
    fill_in "Linea", with: @accumulated_fuel.linea
    fill_in "Litros consumidos", with: @accumulated_fuel.litros_consumidos
    fill_in "N factura", with: @accumulated_fuel.n_factura
    fill_in "No economico", with: @accumulated_fuel.no_economico
    fill_in "Presupuesto", with: @accumulated_fuel.presupuesto
    fill_in "Responsable", with: @accumulated_fuel.responsable
    fill_in "Tipo vehicu", with: @accumulated_fuel.tipo_vehicu
    click_on "Update Accumulated fuel"

    assert_text "Accumulated fuel was successfully updated"
    click_on "Back"
  end

  test "destroying a Accumulated fuel" do
    visit accumulated_fuels_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Accumulated fuel was successfully destroyed"
  end
end
