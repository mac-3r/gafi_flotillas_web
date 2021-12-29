require "application_system_test_case"

class InsuranceReportTicketsTest < ApplicationSystemTestCase
  setup do
    @insurance_report_ticket = insurance_report_tickets(:one)
  end

  test "visiting the index" do
    visit insurance_report_tickets_url
    assert_selector "h1", text: "Insurance Report Tickets"
  end

  test "creating a Insurance report ticket" do
    visit insurance_report_tickets_url
    click_on "New Insurance Report Ticket"

    fill_in "Cargo deducible empleado", with: @insurance_report_ticket.cargo_deducible_empleado
    fill_in "Cargo deducible empresa", with: @insurance_report_ticket.cargo_deducible_empresa
    fill_in "Cedis", with: @insurance_report_ticket.cedis
    fill_in "Coincide", with: @insurance_report_ticket.coincide
    fill_in "Comentarios adicionales", with: @insurance_report_ticket.comentarios_adicionales
    fill_in "Declaracion", with: @insurance_report_ticket.declaracion
    fill_in "Estatus", with: @insurance_report_ticket.estatus
    fill_in "Estatus responsabilidad aseguradora", with: @insurance_report_ticket.estatus_responsabilidad_aseguradora
    fill_in "Estatus responsabilidad gafi", with: @insurance_report_ticket.estatus_responsabilidad_gafi
    fill_in "Estatus vehiculo", with: @insurance_report_ticket.estatus_vehiculo
    fill_in "Fecha ocurrio", with: @insurance_report_ticket.fecha_ocurrio
    fill_in "Fecha reporte", with: @insurance_report_ticket.fecha_reporte
    fill_in "Inciso", with: @insurance_report_ticket.inciso
    fill_in "Modelo", with: @insurance_report_ticket.modelo
    fill_in "Monto siniestro", with: @insurance_report_ticket.monto_siniestro
    fill_in "Numero economico", with: @insurance_report_ticket.numero_economico
    fill_in "Numero poliza", with: @insurance_report_ticket.numero_poliza
    fill_in "Numero serie", with: @insurance_report_ticket.numero_serie
    fill_in "Numero siniestro", with: @insurance_report_ticket.numero_siniestro
    fill_in "Responsable", with: @insurance_report_ticket.responsable
    fill_in "Tipo siniestro", with: @insurance_report_ticket.tipo_siniestro
    fill_in "Type sinisters", with: @insurance_report_ticket.type_sinisters_id
    fill_in "Ubicacion siniestro", with: @insurance_report_ticket.ubicacion_siniestro
    fill_in "Vehicle", with: @insurance_report_ticket.vehicle_id
    fill_in "Vehiculo", with: @insurance_report_ticket.vehiculo
    click_on "Create Insurance report ticket"

    assert_text "Insurance report ticket was successfully created"
    click_on "Back"
  end

  test "updating a Insurance report ticket" do
    visit insurance_report_tickets_url
    click_on "Edit", match: :first

    fill_in "Cargo deducible empleado", with: @insurance_report_ticket.cargo_deducible_empleado
    fill_in "Cargo deducible empresa", with: @insurance_report_ticket.cargo_deducible_empresa
    fill_in "Cedis", with: @insurance_report_ticket.cedis
    fill_in "Coincide", with: @insurance_report_ticket.coincide
    fill_in "Comentarios adicionales", with: @insurance_report_ticket.comentarios_adicionales
    fill_in "Declaracion", with: @insurance_report_ticket.declaracion
    fill_in "Estatus", with: @insurance_report_ticket.estatus
    fill_in "Estatus responsabilidad aseguradora", with: @insurance_report_ticket.estatus_responsabilidad_aseguradora
    fill_in "Estatus responsabilidad gafi", with: @insurance_report_ticket.estatus_responsabilidad_gafi
    fill_in "Estatus vehiculo", with: @insurance_report_ticket.estatus_vehiculo
    fill_in "Fecha ocurrio", with: @insurance_report_ticket.fecha_ocurrio
    fill_in "Fecha reporte", with: @insurance_report_ticket.fecha_reporte
    fill_in "Inciso", with: @insurance_report_ticket.inciso
    fill_in "Modelo", with: @insurance_report_ticket.modelo
    fill_in "Monto siniestro", with: @insurance_report_ticket.monto_siniestro
    fill_in "Numero economico", with: @insurance_report_ticket.numero_economico
    fill_in "Numero poliza", with: @insurance_report_ticket.numero_poliza
    fill_in "Numero serie", with: @insurance_report_ticket.numero_serie
    fill_in "Numero siniestro", with: @insurance_report_ticket.numero_siniestro
    fill_in "Responsable", with: @insurance_report_ticket.responsable
    fill_in "Tipo siniestro", with: @insurance_report_ticket.tipo_siniestro
    fill_in "Type sinisters", with: @insurance_report_ticket.type_sinisters_id
    fill_in "Ubicacion siniestro", with: @insurance_report_ticket.ubicacion_siniestro
    fill_in "Vehicle", with: @insurance_report_ticket.vehicle_id
    fill_in "Vehiculo", with: @insurance_report_ticket.vehiculo
    click_on "Update Insurance report ticket"

    assert_text "Insurance report ticket was successfully updated"
    click_on "Back"
  end

  test "destroying a Insurance report ticket" do
    visit insurance_report_tickets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Insurance report ticket was successfully destroyed"
  end
end
