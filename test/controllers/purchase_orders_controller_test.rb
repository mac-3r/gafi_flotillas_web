require 'test_helper'

class PurchaseOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchase_order = purchase_orders(:one)
  end

  test "should get index" do
    get purchase_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_purchase_order_url
    assert_response :success
  end

  test "should create purchase_order" do
    assert_difference('PurchaseOrder.count') do
      post purchase_orders_url, params: { purchase_order: { catalog_area_id: @purchase_order.catalog_area_id, catalog_branch_id: @purchase_order.catalog_branch_id, cost_center_id: @purchase_order.cost_center_id, fecha: @purchase_order.fecha, monto: @purchase_order.monto, observaciones: @purchase_order.observaciones, usuario: @purchase_order.usuario, vehicle_brand_id: @purchase_order.vehicle_brand_id, vehicle_type_id: @purchase_order.vehicle_type_id } }
    end

    assert_redirected_to purchase_order_url(PurchaseOrder.last)
  end

  test "should show purchase_order" do
    get purchase_order_url(@purchase_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_purchase_order_url(@purchase_order)
    assert_response :success
  end

  test "should update purchase_order" do
    patch purchase_order_url(@purchase_order), params: { purchase_order: { catalog_area_id: @purchase_order.catalog_area_id, catalog_branch_id: @purchase_order.catalog_branch_id, cost_center_id: @purchase_order.cost_center_id, fecha: @purchase_order.fecha, monto: @purchase_order.monto, observaciones: @purchase_order.observaciones, usuario: @purchase_order.usuario, vehicle_brand_id: @purchase_order.vehicle_brand_id, vehicle_type_id: @purchase_order.vehicle_type_id } }
    assert_redirected_to purchase_order_url(@purchase_order)
  end

  test "should destroy purchase_order" do
    assert_difference('PurchaseOrder.count', -1) do
      delete purchase_order_url(@purchase_order)
    end

    assert_redirected_to purchase_orders_url
  end
end
