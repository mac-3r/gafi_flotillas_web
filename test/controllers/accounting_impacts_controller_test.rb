require 'test_helper'

class AccountingImpactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @accounting_impact = accounting_impacts(:one)
  end

  test "should get index" do
    get accounting_impacts_url
    assert_response :success
  end

  test "should get new" do
    get new_accounting_impact_url
    assert_response :success
  end

  test "should create accounting_impact" do
    assert_difference('AccountingImpact.count') do
      post accounting_impacts_url, params: { accounting_impact: { catalog_branches_id: @accounting_impact.catalog_branches_id, combustible: @accounting_impact.combustible, mantenimiento_equipo: @accounting_impact.mantenimiento_equipo, mantenimiento_maquinaria: @accounting_impact.mantenimiento_maquinaria, nombre: @accounting_impact.nombre, permiso: @accounting_impact.permiso, plaqueo: @accounting_impact.plaqueo, seguro: @accounting_impact.seguro, status: @accounting_impact.status } }
    end

    assert_redirected_to accounting_impact_url(AccountingImpact.last)
  end

  test "should show accounting_impact" do
    get accounting_impact_url(@accounting_impact)
    assert_response :success
  end

  test "should get edit" do
    get edit_accounting_impact_url(@accounting_impact)
    assert_response :success
  end

  test "should update accounting_impact" do
    patch accounting_impact_url(@accounting_impact), params: { accounting_impact: { catalog_branches_id: @accounting_impact.catalog_branches_id, combustible: @accounting_impact.combustible, mantenimiento_equipo: @accounting_impact.mantenimiento_equipo, mantenimiento_maquinaria: @accounting_impact.mantenimiento_maquinaria, nombre: @accounting_impact.nombre, permiso: @accounting_impact.permiso, plaqueo: @accounting_impact.plaqueo, seguro: @accounting_impact.seguro, status: @accounting_impact.status } }
    assert_redirected_to accounting_impact_url(@accounting_impact)
  end

  test "should destroy accounting_impact" do
    assert_difference('AccountingImpact.count', -1) do
      delete accounting_impact_url(@accounting_impact)
    end

    assert_redirected_to accounting_impacts_url
  end
end
