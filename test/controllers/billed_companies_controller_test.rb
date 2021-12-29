require 'test_helper'

class BilledCompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @billed_company = billed_companies(:one)
  end

  test "should get index" do
    get billed_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_billed_company_url
    assert_response :success
  end

  test "should create billed_company" do
    assert_difference('BilledCompany.count') do
      post billed_companies_url, params: { billed_company: { clave_jd: @billed_company.clave_jd, nombre: @billed_company.nombre, status: @billed_company.status } }
    end

    assert_redirected_to billed_company_url(BilledCompany.last)
  end

  test "should show billed_company" do
    get billed_company_url(@billed_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_billed_company_url(@billed_company)
    assert_response :success
  end

  test "should update billed_company" do
    patch billed_company_url(@billed_company), params: { billed_company: { clave_jd: @billed_company.clave_jd, nombre: @billed_company.nombre, status: @billed_company.status } }
    assert_redirected_to billed_company_url(@billed_company)
  end

  test "should destroy billed_company" do
    assert_difference('BilledCompany.count', -1) do
      delete billed_company_url(@billed_company)
    end

    assert_redirected_to billed_companies_url
  end
end
