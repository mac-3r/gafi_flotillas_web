require 'test_helper'

class DeliveryAddressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @delivery_address = delivery_addresses(:one)
  end

  test "should get index" do
    get delivery_addresses_url
    assert_response :success
  end

  test "should get new" do
    get new_delivery_address_url
    assert_response :success
  end

  test "should create delivery_address" do
    assert_difference('DeliveryAddress.count') do
      post delivery_addresses_url, params: { delivery_address: { catalog_branch_id: @delivery_address.catalog_branch_id, catalog_company_id: @delivery_address.catalog_company_id, clave: @delivery_address.clave, direccion: @delivery_address.direccion, estatus: @delivery_address.estatus, principal: @delivery_address.principal } }
    end

    assert_redirected_to delivery_address_url(DeliveryAddress.last)
  end

  test "should show delivery_address" do
    get delivery_address_url(@delivery_address)
    assert_response :success
  end

  test "should get edit" do
    get edit_delivery_address_url(@delivery_address)
    assert_response :success
  end

  test "should update delivery_address" do
    patch delivery_address_url(@delivery_address), params: { delivery_address: { catalog_branch_id: @delivery_address.catalog_branch_id, catalog_company_id: @delivery_address.catalog_company_id, clave: @delivery_address.clave, direccion: @delivery_address.direccion, estatus: @delivery_address.estatus, principal: @delivery_address.principal } }
    assert_redirected_to delivery_address_url(@delivery_address)
  end

  test "should destroy delivery_address" do
    assert_difference('DeliveryAddress.count', -1) do
      delete delivery_address_url(@delivery_address)
    end

    assert_redirected_to delivery_addresses_url
  end
end
