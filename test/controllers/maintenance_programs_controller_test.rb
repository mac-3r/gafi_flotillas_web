require 'test_helper'

class MaintenanceProgramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maintenance_program = maintenance_programs(:one)
  end

  test "should get index" do
    get maintenance_programs_url
    assert_response :success
  end

  test "should get new" do
    get new_maintenance_program_url
    assert_response :success
  end

  test "should create maintenance_program" do
    assert_difference('MaintenanceProgram.count') do
      post maintenance_programs_url, params: { maintenance_program: { fecha_proximo_servicio: @maintenance_program.fecha_proximo_servicio, fecha_ultima_afinacion: @maintenance_program.fecha_ultima_afinacion, frecuencia_mantenimiento: @maintenance_program.frecuencia_mantenimiento, km_actual: @maintenance_program.km_actual, km_inicio_ano: @maintenance_program.km_inicio_ano, km_recorrido_curso: @maintenance_program.km_recorrido_curso, kms_proximo_servicio: @maintenance_program.kms_proximo_servicio, kms_ultima_afinacion: @maintenance_program.kms_ultima_afinacion, observaciones: @maintenance_program.observaciones, promedio_mensual: @maintenance_program.promedio_mensual, vehicle_id: @maintenance_program.vehicle_id } }
    end

    assert_redirected_to maintenance_program_url(MaintenanceProgram.last)
  end

  test "should show maintenance_program" do
    get maintenance_program_url(@maintenance_program)
    assert_response :success
  end

  test "should get edit" do
    get edit_maintenance_program_url(@maintenance_program)
    assert_response :success
  end

  test "should update maintenance_program" do
    patch maintenance_program_url(@maintenance_program), params: { maintenance_program: { fecha_proximo_servicio: @maintenance_program.fecha_proximo_servicio, fecha_ultima_afinacion: @maintenance_program.fecha_ultima_afinacion, frecuencia_mantenimiento: @maintenance_program.frecuencia_mantenimiento, km_actual: @maintenance_program.km_actual, km_inicio_ano: @maintenance_program.km_inicio_ano, km_recorrido_curso: @maintenance_program.km_recorrido_curso, kms_proximo_servicio: @maintenance_program.kms_proximo_servicio, kms_ultima_afinacion: @maintenance_program.kms_ultima_afinacion, observaciones: @maintenance_program.observaciones, promedio_mensual: @maintenance_program.promedio_mensual, vehicle_id: @maintenance_program.vehicle_id } }
    assert_redirected_to maintenance_program_url(@maintenance_program)
  end

  test "should destroy maintenance_program" do
    assert_difference('MaintenanceProgram.count', -1) do
      delete maintenance_program_url(@maintenance_program)
    end

    assert_redirected_to maintenance_programs_url
  end
end
