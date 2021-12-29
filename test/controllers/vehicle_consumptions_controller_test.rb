require 'test_helper'

class VehicleConsumptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_consumption = vehicle_consumptions(:one)
  end

  test "should get index" do
    get vehicle_consumptions_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_consumption_url
    assert_response :success
  end

  test "should create vehicle_consumption" do
    assert_difference('VehicleConsumption.count') do
      post vehicle_consumptions_url, params: { vehicle_consumption: { bomba: @vehicle_consumption.bomba, cantidad: @vehicle_consumption.cantidad, catalog_area_id: @vehicle_consumption.catalog_area_id, catalog_brand_id: @vehicle_consumption.catalog_brand_id, customer_id: @vehicle_consumption.customer_id, datos: @vehicle_consumption.datos, despacho: @vehicle_consumption.despacho, estacion: @vehicle_consumption.estacion, fecha: @vehicle_consumption.fecha, hora: @vehicle_consumption.hora, monto: @vehicle_consumption.monto, odometro: @vehicle_consumption.odometro, placa: @vehicle_consumption.placa, producto: @vehicle_consumption.producto, recorrido: @vehicle_consumption.recorrido, rendimiento: @vehicle_consumption.rendimiento, responsable_id: @vehicle_consumption.responsable_id, tarjeta: @vehicle_consumption.tarjeta, vehicle_id: @vehicle_consumption.vehicle_id } }
    end

    assert_redirected_to vehicle_consumption_url(VehicleConsumption.last)
  end

  test "should show vehicle_consumption" do
    get vehicle_consumption_url(@vehicle_consumption)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_consumption_url(@vehicle_consumption)
    assert_response :success
  end

  test "should update vehicle_consumption" do
    patch vehicle_consumption_url(@vehicle_consumption), params: { vehicle_consumption: { bomba: @vehicle_consumption.bomba, cantidad: @vehicle_consumption.cantidad, catalog_area_id: @vehicle_consumption.catalog_area_id, catalog_brand_id: @vehicle_consumption.catalog_brand_id, customer_id: @vehicle_consumption.customer_id, datos: @vehicle_consumption.datos, despacho: @vehicle_consumption.despacho, estacion: @vehicle_consumption.estacion, fecha: @vehicle_consumption.fecha, hora: @vehicle_consumption.hora, monto: @vehicle_consumption.monto, odometro: @vehicle_consumption.odometro, placa: @vehicle_consumption.placa, producto: @vehicle_consumption.producto, recorrido: @vehicle_consumption.recorrido, rendimiento: @vehicle_consumption.rendimiento, responsable_id: @vehicle_consumption.responsable_id, tarjeta: @vehicle_consumption.tarjeta, vehicle_id: @vehicle_consumption.vehicle_id } }
    assert_redirected_to vehicle_consumption_url(@vehicle_consumption)
  end

  test "should destroy vehicle_consumption" do
    assert_difference('VehicleConsumption.count', -1) do
      delete vehicle_consumption_url(@vehicle_consumption)
    end

    assert_redirected_to vehicle_consumptions_url
  end
end
