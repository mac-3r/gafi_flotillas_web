require 'test_helper'

class InsuranceBeneficiariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @insurance_beneficiary = insurance_beneficiaries(:one)
  end

  test "should get index" do
    get insurance_beneficiaries_url
    assert_response :success
  end

  test "should get new" do
    get new_insurance_beneficiary_url
    assert_response :success
  end

  test "should create insurance_beneficiary" do
    assert_difference('InsuranceBeneficiary.count') do
      post insurance_beneficiaries_url, params: { insurance_beneficiary: { clave: @insurance_beneficiary.clave, descripcion: @insurance_beneficiary.descripcion, status: @insurance_beneficiary.status } }
    end

    assert_redirected_to insurance_beneficiary_url(InsuranceBeneficiary.last)
  end

  test "should show insurance_beneficiary" do
    get insurance_beneficiary_url(@insurance_beneficiary)
    assert_response :success
  end

  test "should get edit" do
    get edit_insurance_beneficiary_url(@insurance_beneficiary)
    assert_response :success
  end

  test "should update insurance_beneficiary" do
    patch insurance_beneficiary_url(@insurance_beneficiary), params: { insurance_beneficiary: { clave: @insurance_beneficiary.clave, descripcion: @insurance_beneficiary.descripcion, status: @insurance_beneficiary.status } }
    assert_redirected_to insurance_beneficiary_url(@insurance_beneficiary)
  end

  test "should destroy insurance_beneficiary" do
    assert_difference('InsuranceBeneficiary.count', -1) do
      delete insurance_beneficiary_url(@insurance_beneficiary)
    end

    assert_redirected_to insurance_beneficiaries_url
  end
end
