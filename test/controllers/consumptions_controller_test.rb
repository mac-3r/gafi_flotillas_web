require 'test_helper'

class ConsumptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @consumption = consumptions(:one)
  end

  test "should get index" do
    get consumptions_url
    assert_response :success
  end

  test "should get new" do
    get new_consumption_url
    assert_response :success
  end

  test "should create consumption" do
    assert_difference('Consumption.count') do
      post consumptions_url, params: { consumption: { cargas: @consumption.cargas, estatus: @consumption.estatus, factura: @consumption.factura, fecha_fin: @consumption.fecha_fin, fecha_inicio: @consumption.fecha_inicio, folio: @consumption.folio, monto: @consumption.monto } }
    end

    assert_redirected_to consumption_url(Consumption.last)
  end

  test "should show consumption" do
    get consumption_url(@consumption)
    assert_response :success
  end

  test "should get edit" do
    get edit_consumption_url(@consumption)
    assert_response :success
  end

  test "should update consumption" do
    patch consumption_url(@consumption), params: { consumption: { cargas: @consumption.cargas, estatus: @consumption.estatus, factura: @consumption.factura, fecha_fin: @consumption.fecha_fin, fecha_inicio: @consumption.fecha_inicio, folio: @consumption.folio, monto: @consumption.monto } }
    assert_redirected_to consumption_url(@consumption)
  end

  test "should destroy consumption" do
    assert_difference('Consumption.count', -1) do
      delete consumption_url(@consumption)
    end

    assert_redirected_to consumptions_url
  end
end
