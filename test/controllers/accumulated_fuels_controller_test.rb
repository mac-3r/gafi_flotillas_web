require 'test_helper'

class AccumulatedFuelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @accumulated_fuel = accumulated_fuels(:one)
  end

  test "should get index" do
    get accumulated_fuels_url
    assert_response :success
  end

  test "should get new" do
    get new_accumulated_fuel_url
    assert_response :success
  end

  test "should create accumulated_fuel" do
    assert_difference('AccumulatedFuel.count') do
      post accumulated_fuels_url, params: { accumulated_fuel: { area: @accumulated_fuel.area, cedis: @accumulated_fuel.cedis, fecha_carga: @accumulated_fuel.fecha_carga, fecha_fin: @accumulated_fuel.fecha_fin, fecha_inicio: @accumulated_fuel.fecha_inicio, gasto: @accumulated_fuel.gasto, importe_base: @accumulated_fuel.importe_base, importe_total: @accumulated_fuel.importe_total, km_actual: @accumulated_fuel.km_actual, km_inicial: @accumulated_fuel.km_inicial, km_recorrido: @accumulated_fuel.km_recorrido, linea: @accumulated_fuel.linea, litros_consumidos: @accumulated_fuel.litros_consumidos, n_factura: @accumulated_fuel.n_factura, no_economico: @accumulated_fuel.no_economico, presupuesto: @accumulated_fuel.presupuesto, responsable: @accumulated_fuel.responsable, tipo_vehicu: @accumulated_fuel.tipo_vehicu } }
    end

    assert_redirected_to accumulated_fuel_url(AccumulatedFuel.last)
  end

  test "should show accumulated_fuel" do
    get accumulated_fuel_url(@accumulated_fuel)
    assert_response :success
  end

  test "should get edit" do
    get edit_accumulated_fuel_url(@accumulated_fuel)
    assert_response :success
  end

  test "should update accumulated_fuel" do
    patch accumulated_fuel_url(@accumulated_fuel), params: { accumulated_fuel: { area: @accumulated_fuel.area, cedis: @accumulated_fuel.cedis, fecha_carga: @accumulated_fuel.fecha_carga, fecha_fin: @accumulated_fuel.fecha_fin, fecha_inicio: @accumulated_fuel.fecha_inicio, gasto: @accumulated_fuel.gasto, importe_base: @accumulated_fuel.importe_base, importe_total: @accumulated_fuel.importe_total, km_actual: @accumulated_fuel.km_actual, km_inicial: @accumulated_fuel.km_inicial, km_recorrido: @accumulated_fuel.km_recorrido, linea: @accumulated_fuel.linea, litros_consumidos: @accumulated_fuel.litros_consumidos, n_factura: @accumulated_fuel.n_factura, no_economico: @accumulated_fuel.no_economico, presupuesto: @accumulated_fuel.presupuesto, responsable: @accumulated_fuel.responsable, tipo_vehicu: @accumulated_fuel.tipo_vehicu } }
    assert_redirected_to accumulated_fuel_url(@accumulated_fuel)
  end

  test "should destroy accumulated_fuel" do
    assert_difference('AccumulatedFuel.count', -1) do
      delete accumulated_fuel_url(@accumulated_fuel)
    end

    assert_redirected_to accumulated_fuels_url
  end
end
