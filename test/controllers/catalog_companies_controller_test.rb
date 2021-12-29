require 'test_helper'

class CatalogCompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_company = catalog_companies(:one)
  end

  test "should get index" do
    get catalog_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_company_url
    assert_response :success
  end

  test "should create catalog_company" do
    assert_difference('CatalogCompany.count') do
      post catalog_companies_url, params: { catalog_company: { clave: @catalog_company.clave, nombre: @catalog_company.nombre, status: @catalog_company.status } }
    end

    assert_redirected_to catalog_company_url(CatalogCompany.last)
  end

  test "should show catalog_company" do
    get catalog_company_url(@catalog_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_company_url(@catalog_company)
    assert_response :success
  end

  test "should update catalog_company" do
    patch catalog_company_url(@catalog_company), params: { catalog_company: { clave: @catalog_company.clave, nombre: @catalog_company.nombre, status: @catalog_company.status } }
    assert_redirected_to catalog_company_url(@catalog_company)
  end

  test "should destroy catalog_company" do
    assert_difference('CatalogCompany.count', -1) do
      delete catalog_company_url(@catalog_company)
    end

    assert_redirected_to catalog_companies_url
  end
end
