require 'test_helper'

class CatalogWorkshopsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_workshop = catalog_workshops(:one)
  end

  test "should get index" do
    get catalog_workshops_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_workshop_url
    assert_response :success
  end

  test "should create catalog_workshop" do
    assert_difference('CatalogWorkshop.count') do
      post catalog_workshops_url, params: { catalog_workshop: { catalog_branch_id: @catalog_workshop.catalog_branch_id, clave: @catalog_workshop.clave, correo: @catalog_workshop.correo, domicilio: @catalog_workshop.domicilio, especialidad: @catalog_workshop.especialidad, nombre_taller: @catalog_workshop.nombre_taller, razonsocial: @catalog_workshop.razonsocial, responsable: @catalog_workshop.responsable, telefono: @catalog_workshop.telefono, vigente: @catalog_workshop.vigente } }
    end

    assert_redirected_to catalog_workshop_url(CatalogWorkshop.last)
  end

  test "should show catalog_workshop" do
    get catalog_workshop_url(@catalog_workshop)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_workshop_url(@catalog_workshop)
    assert_response :success
  end

  test "should update catalog_workshop" do
    patch catalog_workshop_url(@catalog_workshop), params: { catalog_workshop: { catalog_branch_id: @catalog_workshop.catalog_branch_id, clave: @catalog_workshop.clave, correo: @catalog_workshop.correo, domicilio: @catalog_workshop.domicilio, especialidad: @catalog_workshop.especialidad, nombre_taller: @catalog_workshop.nombre_taller, razonsocial: @catalog_workshop.razonsocial, responsable: @catalog_workshop.responsable, telefono: @catalog_workshop.telefono, vigente: @catalog_workshop.vigente } }
    assert_redirected_to catalog_workshop_url(@catalog_workshop)
  end

  test "should destroy catalog_workshop" do
    assert_difference('CatalogWorkshop.count', -1) do
      delete catalog_workshop_url(@catalog_workshop)
    end

    assert_redirected_to catalog_workshops_url
  end
end
