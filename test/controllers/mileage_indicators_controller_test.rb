require 'test_helper'

class MileageIndicatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mileage_indicator = mileage_indicators(:one)
  end

  test "should get index" do
    get mileage_indicators_url
    assert_response :success
  end

  test "should get new" do
    get new_mileage_indicator_url
    assert_response :success
  end

  test "should create mileage_indicator" do
    assert_difference('MileageIndicator.count') do
      post mileage_indicators_url, params: { mileage_indicator: { fecha: @mileage_indicator.fecha, km_actual: @mileage_indicator.km_actual, vehicle_id: @mileage_indicator.vehicle_id } }
    end

    assert_redirected_to mileage_indicator_url(MileageIndicator.last)
  end

  test "should show mileage_indicator" do
    get mileage_indicator_url(@mileage_indicator)
    assert_response :success
  end

  test "should get edit" do
    get edit_mileage_indicator_url(@mileage_indicator)
    assert_response :success
  end

  test "should update mileage_indicator" do
    patch mileage_indicator_url(@mileage_indicator), params: { mileage_indicator: { fecha: @mileage_indicator.fecha, km_actual: @mileage_indicator.km_actual, vehicle_id: @mileage_indicator.vehicle_id } }
    assert_redirected_to mileage_indicator_url(@mileage_indicator)
  end

  test "should destroy mileage_indicator" do
    assert_difference('MileageIndicator.count', -1) do
      delete mileage_indicator_url(@mileage_indicator)
    end

    assert_redirected_to mileage_indicators_url
  end
end
