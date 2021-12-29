require 'test_helper'

class TicketTireBatteriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticket_tire_battery = ticket_tire_batteries(:one)
  end

  test "should get index" do
    get ticket_tire_batteries_url
    assert_response :success
  end

  test "should get new" do
    get new_ticket_tire_battery_url
    assert_response :success
  end

  test "should create ticket_tire_battery" do
    assert_difference('TicketTireBattery.count') do
      post ticket_tire_batteries_url, params: { ticket_tire_battery: { cantidad: @ticket_tire_battery.cantidad, dot: @ticket_tire_battery.dot, estatus: @ticket_tire_battery.estatus, fecha: @ticket_tire_battery.fecha, tipo: @ticket_tire_battery.tipo, vehicle_id: @ticket_tire_battery.vehicle_id } }
    end

    assert_redirected_to ticket_tire_battery_url(TicketTireBattery.last)
  end

  test "should show ticket_tire_battery" do
    get ticket_tire_battery_url(@ticket_tire_battery)
    assert_response :success
  end

  test "should get edit" do
    get edit_ticket_tire_battery_url(@ticket_tire_battery)
    assert_response :success
  end

  test "should update ticket_tire_battery" do
    patch ticket_tire_battery_url(@ticket_tire_battery), params: { ticket_tire_battery: { cantidad: @ticket_tire_battery.cantidad, dot: @ticket_tire_battery.dot, estatus: @ticket_tire_battery.estatus, fecha: @ticket_tire_battery.fecha, tipo: @ticket_tire_battery.tipo, vehicle_id: @ticket_tire_battery.vehicle_id } }
    assert_redirected_to ticket_tire_battery_url(@ticket_tire_battery)
  end

  test "should destroy ticket_tire_battery" do
    assert_difference('TicketTireBattery.count', -1) do
      delete ticket_tire_battery_url(@ticket_tire_battery)
    end

    assert_redirected_to ticket_tire_batteries_url
  end
end
