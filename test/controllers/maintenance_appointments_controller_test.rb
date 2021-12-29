require 'test_helper'

class MaintenanceAppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maintenance_appointment = maintenance_appointments(:one)
  end

  test "should get index" do
    get maintenance_appointments_url
    assert_response :success
  end

  test "should get new" do
    get new_maintenance_appointment_url
    assert_response :success
  end

  test "should create maintenance_appointment" do
    assert_difference('MaintenanceAppointment.count') do
      post maintenance_appointments_url, params: { maintenance_appointment: { catalog_workshop_id: @maintenance_appointment.catalog_workshop_id, fecha_cita: @maintenance_appointment.fecha_cita, status: @maintenance_appointment.status, vehicle_id: @maintenance_appointment.vehicle_id } }
    end

    assert_redirected_to maintenance_appointment_url(MaintenanceAppointment.last)
  end

  test "should show maintenance_appointment" do
    get maintenance_appointment_url(@maintenance_appointment)
    assert_response :success
  end

  test "should get edit" do
    get edit_maintenance_appointment_url(@maintenance_appointment)
    assert_response :success
  end

  test "should update maintenance_appointment" do
    patch maintenance_appointment_url(@maintenance_appointment), params: { maintenance_appointment: { catalog_workshop_id: @maintenance_appointment.catalog_workshop_id, fecha_cita: @maintenance_appointment.fecha_cita, status: @maintenance_appointment.status, vehicle_id: @maintenance_appointment.vehicle_id } }
    assert_redirected_to maintenance_appointment_url(@maintenance_appointment)
  end

  test "should destroy maintenance_appointment" do
    assert_difference('MaintenanceAppointment.count', -1) do
      delete maintenance_appointment_url(@maintenance_appointment)
    end

    assert_redirected_to maintenance_appointments_url
  end
end
