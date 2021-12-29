require "application_system_test_case"

class CatalogWorkshopsTest < ApplicationSystemTestCase
  setup do
    @catalog_workshop = catalog_workshops(:one)
  end

  test "visiting the index" do
    visit catalog_workshops_url
    assert_selector "h1", text: "Catalog Workshops"
  end

  test "creating a Catalog workshop" do
    visit catalog_workshops_url
    click_on "New Catalog Workshop"

    fill_in "Catalog branch", with: @catalog_workshop.catalog_branch_id
    fill_in "Clave", with: @catalog_workshop.clave
    fill_in "Correo", with: @catalog_workshop.correo
    fill_in "Domicilio", with: @catalog_workshop.domicilio
    fill_in "Especialidad", with: @catalog_workshop.especialidad
    fill_in "Nombre taller", with: @catalog_workshop.nombre_taller
    fill_in "Razonsocial", with: @catalog_workshop.razonsocial
    fill_in "Responsable", with: @catalog_workshop.responsable
    fill_in "Telefono", with: @catalog_workshop.telefono
    check "Vigente" if @catalog_workshop.vigente
    click_on "Create Catalog workshop"

    assert_text "Catalog workshop was successfully created"
    click_on "Back"
  end

  test "updating a Catalog workshop" do
    visit catalog_workshops_url
    click_on "Edit", match: :first

    fill_in "Catalog branch", with: @catalog_workshop.catalog_branch_id
    fill_in "Clave", with: @catalog_workshop.clave
    fill_in "Correo", with: @catalog_workshop.correo
    fill_in "Domicilio", with: @catalog_workshop.domicilio
    fill_in "Especialidad", with: @catalog_workshop.especialidad
    fill_in "Nombre taller", with: @catalog_workshop.nombre_taller
    fill_in "Razonsocial", with: @catalog_workshop.razonsocial
    fill_in "Responsable", with: @catalog_workshop.responsable
    fill_in "Telefono", with: @catalog_workshop.telefono
    check "Vigente" if @catalog_workshop.vigente
    click_on "Update Catalog workshop"

    assert_text "Catalog workshop was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog workshop" do
    visit catalog_workshops_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog workshop was successfully destroyed"
  end
end
