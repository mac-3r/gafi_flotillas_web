require 'test_helper'

class CatalogResponsivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_responsife = catalog_responsives(:one)
  end

  test "should get index" do
    get catalog_responsives_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_responsife_url
    assert_response :success
  end

  test "should create catalog_responsife" do
    assert_difference('CatalogResponsife.count') do
      post catalog_responsives_url, params: { catalog_responsife: { catalog_area_id: @catalog_responsife.catalog_area_id, catalog_branch_id: @catalog_responsife.catalog_branch_id, catalog_personal_id: @catalog_responsife.catalog_personal_id, clave: @catalog_responsife.clave, correo: @catalog_responsife.correo, status: @catalog_responsife.status } }
    end

    assert_redirected_to catalog_responsife_url(CatalogResponsife.last)
  end

  test "should show catalog_responsife" do
    get catalog_responsife_url(@catalog_responsife)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_responsife_url(@catalog_responsife)
    assert_response :success
  end

  test "should update catalog_responsife" do
    patch catalog_responsife_url(@catalog_responsife), params: { catalog_responsife: { catalog_area_id: @catalog_responsife.catalog_area_id, catalog_branch_id: @catalog_responsife.catalog_branch_id, catalog_personal_id: @catalog_responsife.catalog_personal_id, clave: @catalog_responsife.clave, correo: @catalog_responsife.correo, status: @catalog_responsife.status } }
    assert_redirected_to catalog_responsife_url(@catalog_responsife)
  end

  test "should destroy catalog_responsife" do
    assert_difference('CatalogResponsife.count', -1) do
      delete catalog_responsife_url(@catalog_responsife)
    end

    assert_redirected_to catalog_responsives_url
  end
end
