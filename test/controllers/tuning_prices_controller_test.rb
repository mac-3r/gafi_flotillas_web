require 'test_helper'

class TuningPricesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tuning_price = tuning_prices(:one)
  end

  test "should get index" do
    get tuning_prices_url
    assert_response :success
  end

  test "should get new" do
    get new_tuning_price_url
    assert_response :success
  end

  test "should create tuning_price" do
    assert_difference('TuningPrice.count') do
      post tuning_prices_url, params: { tuning_price: { catalog_branch_id: @tuning_price.catalog_branch_id, catalog_brand_id: @tuning_price.catalog_brand_id, catalog_workshop_id: @tuning_price.catalog_workshop_id, clave: @tuning_price.clave, precio_mayor: @tuning_price.precio_mayor, precio_menor: @tuning_price.precio_menor, status: @tuning_price.status } }
    end

    assert_redirected_to tuning_price_url(TuningPrice.last)
  end

  test "should show tuning_price" do
    get tuning_price_url(@tuning_price)
    assert_response :success
  end

  test "should get edit" do
    get edit_tuning_price_url(@tuning_price)
    assert_response :success
  end

  test "should update tuning_price" do
    patch tuning_price_url(@tuning_price), params: { tuning_price: { catalog_branch_id: @tuning_price.catalog_branch_id, catalog_brand_id: @tuning_price.catalog_brand_id, catalog_workshop_id: @tuning_price.catalog_workshop_id, clave: @tuning_price.clave, precio_mayor: @tuning_price.precio_mayor, precio_menor: @tuning_price.precio_menor, status: @tuning_price.status } }
    assert_redirected_to tuning_price_url(@tuning_price)
  end

  test "should destroy tuning_price" do
    assert_difference('TuningPrice.count', -1) do
      delete tuning_price_url(@tuning_price)
    end

    assert_redirected_to tuning_prices_url
  end
end
