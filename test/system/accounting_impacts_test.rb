require "application_system_test_case"

class AccountingImpactsTest < ApplicationSystemTestCase
  setup do
    @accounting_impact = accounting_impacts(:one)
  end

  test "visiting the index" do
    visit accounting_impacts_url
    assert_selector "h1", text: "Accounting Impacts"
  end

  test "creating a Accounting impact" do
    visit accounting_impacts_url
    click_on "New Accounting Impact"

    fill_in "Catalog branches", with: @accounting_impact.catalog_branches_id
    fill_in "Combustible", with: @accounting_impact.combustible
    fill_in "Mantenimiento equipo", with: @accounting_impact.mantenimiento_equipo
    fill_in "Mantenimiento maquinaria", with: @accounting_impact.mantenimiento_maquinaria
    fill_in "Nombre", with: @accounting_impact.nombre
    fill_in "Permiso", with: @accounting_impact.permiso
    fill_in "Plaqueo", with: @accounting_impact.plaqueo
    fill_in "Seguro", with: @accounting_impact.seguro
    check "Status" if @accounting_impact.status
    click_on "Create Accounting impact"

    assert_text "Accounting impact was successfully created"
    click_on "Back"
  end

  test "updating a Accounting impact" do
    visit accounting_impacts_url
    click_on "Edit", match: :first

    fill_in "Catalog branches", with: @accounting_impact.catalog_branches_id
    fill_in "Combustible", with: @accounting_impact.combustible
    fill_in "Mantenimiento equipo", with: @accounting_impact.mantenimiento_equipo
    fill_in "Mantenimiento maquinaria", with: @accounting_impact.mantenimiento_maquinaria
    fill_in "Nombre", with: @accounting_impact.nombre
    fill_in "Permiso", with: @accounting_impact.permiso
    fill_in "Plaqueo", with: @accounting_impact.plaqueo
    fill_in "Seguro", with: @accounting_impact.seguro
    check "Status" if @accounting_impact.status
    click_on "Update Accounting impact"

    assert_text "Accounting impact was successfully updated"
    click_on "Back"
  end

  test "destroying a Accounting impact" do
    visit accounting_impacts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Accounting impact was successfully destroyed"
  end
end
