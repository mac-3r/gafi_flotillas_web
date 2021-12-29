require 'test_helper'

class VehicleItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_item = vehicle_items(:one)
  end

  test "should get index" do
    get vehicle_items_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_item_url
    assert_response :success
  end

  test "should create vehicle_item" do
    assert_difference('VehicleItem.count') do
      post vehicle_items_url, params: { vehicle_item: { codigo: @vehicle_item.codigo, date: @vehicle_item.date, estatus: @vehicle_item.estatus, fecha_compra: @vehicle_item.fecha_compra, km_fin: @vehicle_item.km_fin, km_inicio: @vehicle_item.km_inicio, string: @vehicle_item.string, tipo: @vehicle_item.tipo, vehicle_id: @vehicle_item.vehicle_id } }
    end

    assert_redirected_to vehicle_item_url(VehicleItem.last)
  end

  test "should show vehicle_item" do
    get vehicle_item_url(@vehicle_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_item_url(@vehicle_item)
    assert_response :success
  end

  test "should update vehicle_item" do
    patch vehicle_item_url(@vehicle_item), params: { vehicle_item: { codigo: @vehicle_item.codigo, date: @vehicle_item.date, estatus: @vehicle_item.estatus, fecha_compra: @vehicle_item.fecha_compra, km_fin: @vehicle_item.km_fin, km_inicio: @vehicle_item.km_inicio, string: @vehicle_item.string, tipo: @vehicle_item.tipo, vehicle_id: @vehicle_item.vehicle_id } }
    assert_redirected_to vehicle_item_url(@vehicle_item)
  end

  test "should destroy vehicle_item" do
    assert_difference('VehicleItem.count', -1) do
      delete vehicle_item_url(@vehicle_item)
    end

    assert_redirected_to vehicle_items_url
  end
end
