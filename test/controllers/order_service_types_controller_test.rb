require 'test_helper'

class OrderServiceTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order_service_type = order_service_types(:one)
  end

  test "should get index" do
    get order_service_types_url
    assert_response :success
  end

  test "should get new" do
    get new_order_service_type_url
    assert_response :success
  end

  test "should create order_service_type" do
    assert_difference('OrderServiceType.count') do
      post order_service_types_url, params: { order_service_type: { descripcion: @order_service_type.descripcion, nombre: @order_service_type.nombre, origen: @order_service_type.origen, status: @order_service_type.status } }
    end

    assert_redirected_to order_service_type_url(OrderServiceType.last)
  end

  test "should show order_service_type" do
    get order_service_type_url(@order_service_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_service_type_url(@order_service_type)
    assert_response :success
  end

  test "should update order_service_type" do
    patch order_service_type_url(@order_service_type), params: { order_service_type: { descripcion: @order_service_type.descripcion, nombre: @order_service_type.nombre, origen: @order_service_type.origen, status: @order_service_type.status } }
    assert_redirected_to order_service_type_url(@order_service_type)
  end

  test "should destroy order_service_type" do
    assert_difference('OrderServiceType.count', -1) do
      delete order_service_type_url(@order_service_type)
    end

    assert_redirected_to order_service_types_url
  end
end
