require "application_system_test_case"

class BranchOfficesTest < ApplicationSystemTestCase
  setup do
    @branch_office = branch_offices(:one)
  end

  test "visiting the index" do
    visit branch_offices_url
    assert_selector "h1", text: "Branch Offices"
  end

  test "creating a Branch office" do
    visit branch_offices_url
    click_on "New Branch Office"

    fill_in "Catalog company", with: @branch_office.catalog_company_id
    fill_in "Clave clasificacion", with: @branch_office.clave_clasificacion
    fill_in "Clave jd", with: @branch_office.clave_jd
    fill_in "Descripcion", with: @branch_office.descripcion
    check "Status" if @branch_office.status
    fill_in "Unidad negocio", with: @branch_office.unidad_negocio
    click_on "Create Branch office"

    assert_text "Branch office was successfully created"
    click_on "Back"
  end

  test "updating a Branch office" do
    visit branch_offices_url
    click_on "Edit", match: :first

    fill_in "Catalog company", with: @branch_office.catalog_company_id
    fill_in "Clave clasificacion", with: @branch_office.clave_clasificacion
    fill_in "Clave jd", with: @branch_office.clave_jd
    fill_in "Descripcion", with: @branch_office.descripcion
    check "Status" if @branch_office.status
    fill_in "Unidad negocio", with: @branch_office.unidad_negocio
    click_on "Update Branch office"

    assert_text "Branch office was successfully updated"
    click_on "Back"
  end

  test "destroying a Branch office" do
    visit branch_offices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Branch office was successfully destroyed"
  end
end
