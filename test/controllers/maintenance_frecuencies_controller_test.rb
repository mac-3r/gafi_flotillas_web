require 'test_helper'

class MaintenanceFrecuenciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maintenance_frecuency = maintenance_frecuencies(:one)
  end

  test "should get index" do
    get maintenance_frecuencies_url
    assert_response :success
  end

  test "should get new" do
    get new_maintenance_frecuency_url
    assert_response :success
  end

  test "should create maintenance_frecuency" do
    assert_difference('MaintenanceFrecuency.count') do
      post maintenance_frecuencies_url, params: { maintenance_frecuency: { frecuencia: @maintenance_frecuency.frecuencia, mensual_recorrido: @maintenance_frecuency.mensual_recorrido, vehicle_id: @maintenance_frecuency.vehicle_id } }
    end

    assert_redirected_to maintenance_frecuency_url(MaintenanceFrecuency.last)
  end

  test "should show maintenance_frecuency" do
    get maintenance_frecuency_url(@maintenance_frecuency)
    assert_response :success
  end

  test "should get edit" do
    get edit_maintenance_frecuency_url(@maintenance_frecuency)
    assert_response :success
  end

  test "should update maintenance_frecuency" do
    patch maintenance_frecuency_url(@maintenance_frecuency), params: { maintenance_frecuency: { frecuencia: @maintenance_frecuency.frecuencia, mensual_recorrido: @maintenance_frecuency.mensual_recorrido, vehicle_id: @maintenance_frecuency.vehicle_id } }
    assert_redirected_to maintenance_frecuency_url(@maintenance_frecuency)
  end

  test "should destroy maintenance_frecuency" do
    assert_difference('MaintenanceFrecuency.count', -1) do
      delete maintenance_frecuency_url(@maintenance_frecuency)
    end

    assert_redirected_to maintenance_frecuencies_url
  end
end
