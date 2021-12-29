require "application_system_test_case"

class MaintenanceProgramsTest < ApplicationSystemTestCase
  setup do
    @maintenance_program = maintenance_programs(:one)
  end

  test "visiting the index" do
    visit maintenance_programs_url
    assert_selector "h1", text: "Maintenance Programs"
  end

  test "creating a Maintenance program" do
    visit maintenance_programs_url
    click_on "New Maintenance Program"

    fill_in "Fecha proximo servicio", with: @maintenance_program.fecha_proximo_servicio
    fill_in "Fecha ultima afinacion", with: @maintenance_program.fecha_ultima_afinacion
    fill_in "Frecuencia mantenimiento", with: @maintenance_program.frecuencia_mantenimiento
    fill_in "Km actual", with: @maintenance_program.km_actual
    fill_in "Km inicio ano", with: @maintenance_program.km_inicio_ano
    fill_in "Km recorrido curso", with: @maintenance_program.km_recorrido_curso
    fill_in "Kms proximo servicio", with: @maintenance_program.kms_proximo_servicio
    fill_in "Kms ultima afinacion", with: @maintenance_program.kms_ultima_afinacion
    fill_in "Observaciones", with: @maintenance_program.observaciones
    fill_in "Promedio mensual", with: @maintenance_program.promedio_mensual
    fill_in "Vehicle", with: @maintenance_program.vehicle_id
    click_on "Create Maintenance program"

    assert_text "Maintenance program was successfully created"
    click_on "Back"
  end

  test "updating a Maintenance program" do
    visit maintenance_programs_url
    click_on "Edit", match: :first

    fill_in "Fecha proximo servicio", with: @maintenance_program.fecha_proximo_servicio
    fill_in "Fecha ultima afinacion", with: @maintenance_program.fecha_ultima_afinacion
    fill_in "Frecuencia mantenimiento", with: @maintenance_program.frecuencia_mantenimiento
    fill_in "Km actual", with: @maintenance_program.km_actual
    fill_in "Km inicio ano", with: @maintenance_program.km_inicio_ano
    fill_in "Km recorrido curso", with: @maintenance_program.km_recorrido_curso
    fill_in "Kms proximo servicio", with: @maintenance_program.kms_proximo_servicio
    fill_in "Kms ultima afinacion", with: @maintenance_program.kms_ultima_afinacion
    fill_in "Observaciones", with: @maintenance_program.observaciones
    fill_in "Promedio mensual", with: @maintenance_program.promedio_mensual
    fill_in "Vehicle", with: @maintenance_program.vehicle_id
    click_on "Update Maintenance program"

    assert_text "Maintenance program was successfully updated"
    click_on "Back"
  end

  test "destroying a Maintenance program" do
    visit maintenance_programs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Maintenance program was successfully destroyed"
  end
end
