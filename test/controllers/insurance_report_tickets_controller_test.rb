require 'test_helper'

class InsuranceReportTicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @insurance_report_ticket = insurance_report_tickets(:one)
  end

  test "should get index" do
    get insurance_report_tickets_url
    assert_response :success
  end

  test "should get new" do
    get new_insurance_report_ticket_url
    assert_response :success
  end

  test "should create insurance_report_ticket" do
    assert_difference('InsuranceReportTicket.count') do
      post insurance_report_tickets_url, params: { insurance_report_ticket: { cargo_deducible_empleado: @insurance_report_ticket.cargo_deducible_empleado, cargo_deducible_empresa: @insurance_report_ticket.cargo_deducible_empresa, cedis: @insurance_report_ticket.cedis, coincide: @insurance_report_ticket.coincide, comentarios_adicionales: @insurance_report_ticket.comentarios_adicionales, declaracion: @insurance_report_ticket.declaracion, estatus: @insurance_report_ticket.estatus, estatus_responsabilidad_aseguradora: @insurance_report_ticket.estatus_responsabilidad_aseguradora, estatus_responsabilidad_gafi: @insurance_report_ticket.estatus_responsabilidad_gafi, estatus_vehiculo: @insurance_report_ticket.estatus_vehiculo, fecha_ocurrio: @insurance_report_ticket.fecha_ocurrio, fecha_reporte: @insurance_report_ticket.fecha_reporte, inciso: @insurance_report_ticket.inciso, modelo: @insurance_report_ticket.modelo, monto_siniestro: @insurance_report_ticket.monto_siniestro, numero_economico: @insurance_report_ticket.numero_economico, numero_poliza: @insurance_report_ticket.numero_poliza, numero_serie: @insurance_report_ticket.numero_serie, numero_siniestro: @insurance_report_ticket.numero_siniestro, responsable: @insurance_report_ticket.responsable, tipo_siniestro: @insurance_report_ticket.tipo_siniestro, type_sinisters_id: @insurance_report_ticket.type_sinisters_id, ubicacion_siniestro: @insurance_report_ticket.ubicacion_siniestro, vehicle_id: @insurance_report_ticket.vehicle_id, vehiculo: @insurance_report_ticket.vehiculo } }
    end

    assert_redirected_to insurance_report_ticket_url(InsuranceReportTicket.last)
  end

  test "should show insurance_report_ticket" do
    get insurance_report_ticket_url(@insurance_report_ticket)
    assert_response :success
  end

  test "should get edit" do
    get edit_insurance_report_ticket_url(@insurance_report_ticket)
    assert_response :success
  end

  test "should update insurance_report_ticket" do
    patch insurance_report_ticket_url(@insurance_report_ticket), params: { insurance_report_ticket: { cargo_deducible_empleado: @insurance_report_ticket.cargo_deducible_empleado, cargo_deducible_empresa: @insurance_report_ticket.cargo_deducible_empresa, cedis: @insurance_report_ticket.cedis, coincide: @insurance_report_ticket.coincide, comentarios_adicionales: @insurance_report_ticket.comentarios_adicionales, declaracion: @insurance_report_ticket.declaracion, estatus: @insurance_report_ticket.estatus, estatus_responsabilidad_aseguradora: @insurance_report_ticket.estatus_responsabilidad_aseguradora, estatus_responsabilidad_gafi: @insurance_report_ticket.estatus_responsabilidad_gafi, estatus_vehiculo: @insurance_report_ticket.estatus_vehiculo, fecha_ocurrio: @insurance_report_ticket.fecha_ocurrio, fecha_reporte: @insurance_report_ticket.fecha_reporte, inciso: @insurance_report_ticket.inciso, modelo: @insurance_report_ticket.modelo, monto_siniestro: @insurance_report_ticket.monto_siniestro, numero_economico: @insurance_report_ticket.numero_economico, numero_poliza: @insurance_report_ticket.numero_poliza, numero_serie: @insurance_report_ticket.numero_serie, numero_siniestro: @insurance_report_ticket.numero_siniestro, responsable: @insurance_report_ticket.responsable, tipo_siniestro: @insurance_report_ticket.tipo_siniestro, type_sinisters_id: @insurance_report_ticket.type_sinisters_id, ubicacion_siniestro: @insurance_report_ticket.ubicacion_siniestro, vehicle_id: @insurance_report_ticket.vehicle_id, vehiculo: @insurance_report_ticket.vehiculo } }
    assert_redirected_to insurance_report_ticket_url(@insurance_report_ticket)
  end

  test "should destroy insurance_report_ticket" do
    assert_difference('InsuranceReportTicket.count', -1) do
      delete insurance_report_ticket_url(@insurance_report_ticket)
    end

    assert_redirected_to insurance_report_tickets_url
  end
end
