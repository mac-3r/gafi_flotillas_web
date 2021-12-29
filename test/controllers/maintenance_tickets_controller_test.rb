require 'test_helper'

class MaintenanceTicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maintenance_ticket = maintenance_tickets(:one)
  end

  test "should get index" do
    get maintenance_tickets_url
    assert_response :success
  end

  test "should get new" do
    get new_maintenance_ticket_url
    assert_response :success
  end

  test "should create maintenance_ticket" do
    assert_difference('MaintenanceTicket.count') do
      post maintenance_tickets_url, params: { maintenance_ticket: { descripcion: @maintenance_ticket.descripcion, estatus: @maintenance_ticket.estatus, fecha_alta: @maintenance_ticket.fecha_alta, vehicle_id: @maintenance_ticket.vehicle_id } }
    end

    assert_redirected_to maintenance_ticket_url(MaintenanceTicket.last)
  end

  test "should show maintenance_ticket" do
    get maintenance_ticket_url(@maintenance_ticket)
    assert_response :success
  end

  test "should get edit" do
    get edit_maintenance_ticket_url(@maintenance_ticket)
    assert_response :success
  end

  test "should update maintenance_ticket" do
    patch maintenance_ticket_url(@maintenance_ticket), params: { maintenance_ticket: { descripcion: @maintenance_ticket.descripcion, estatus: @maintenance_ticket.estatus, fecha_alta: @maintenance_ticket.fecha_alta, vehicle_id: @maintenance_ticket.vehicle_id } }
    assert_redirected_to maintenance_ticket_url(@maintenance_ticket)
  end

  test "should destroy maintenance_ticket" do
    assert_difference('MaintenanceTicket.count', -1) do
      delete maintenance_ticket_url(@maintenance_ticket)
    end

    assert_redirected_to maintenance_tickets_url
  end
end
