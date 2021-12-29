require 'test_helper'

class AgencyMileageIndicatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agency_mileage_indicator = agency_mileage_indicators(:one)
  end

  test "should get index" do
    get agency_mileage_indicators_url
    assert_response :success
  end

  test "should get new" do
    get new_agency_mileage_indicator_url
    assert_response :success
  end

  test "should create agency_mileage_indicator" do
    assert_difference('AgencyMileageIndicator.count') do
      post agency_mileage_indicators_url, params: { agency_mileage_indicator: { fecha: @agency_mileage_indicator.fecha, km_actual: @agency_mileage_indicator.km_actual, tipo: @agency_mileage_indicator.tipo, vehicle_id: @agency_mileage_indicator.vehicle_id } }
    end

    assert_redirected_to agency_mileage_indicator_url(AgencyMileageIndicator.last)
  end

  test "should show agency_mileage_indicator" do
    get agency_mileage_indicator_url(@agency_mileage_indicator)
    assert_response :success
  end

  test "should get edit" do
    get edit_agency_mileage_indicator_url(@agency_mileage_indicator)
    assert_response :success
  end

  test "should update agency_mileage_indicator" do
    patch agency_mileage_indicator_url(@agency_mileage_indicator), params: { agency_mileage_indicator: { fecha: @agency_mileage_indicator.fecha, km_actual: @agency_mileage_indicator.km_actual, tipo: @agency_mileage_indicator.tipo, vehicle_id: @agency_mileage_indicator.vehicle_id } }
    assert_redirected_to agency_mileage_indicator_url(@agency_mileage_indicator)
  end

  test "should destroy agency_mileage_indicator" do
    assert_difference('AgencyMileageIndicator.count', -1) do
      delete agency_mileage_indicator_url(@agency_mileage_indicator)
    end

    assert_redirected_to agency_mileage_indicators_url
  end
end
