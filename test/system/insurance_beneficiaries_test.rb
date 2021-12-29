require "application_system_test_case"

class InsuranceBeneficiariesTest < ApplicationSystemTestCase
  setup do
    @insurance_beneficiary = insurance_beneficiaries(:one)
  end

  test "visiting the index" do
    visit insurance_beneficiaries_url
    assert_selector "h1", text: "Insurance Beneficiaries"
  end

  test "creating a Insurance beneficiary" do
    visit insurance_beneficiaries_url
    click_on "New Insurance Beneficiary"

    fill_in "Clave", with: @insurance_beneficiary.clave
    fill_in "Descripcion", with: @insurance_beneficiary.descripcion
    check "Status" if @insurance_beneficiary.status
    click_on "Create Insurance beneficiary"

    assert_text "Insurance beneficiary was successfully created"
    click_on "Back"
  end

  test "updating a Insurance beneficiary" do
    visit insurance_beneficiaries_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @insurance_beneficiary.clave
    fill_in "Descripcion", with: @insurance_beneficiary.descripcion
    check "Status" if @insurance_beneficiary.status
    click_on "Update Insurance beneficiary"

    assert_text "Insurance beneficiary was successfully updated"
    click_on "Back"
  end

  test "destroying a Insurance beneficiary" do
    visit insurance_beneficiaries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Insurance beneficiary was successfully destroyed"
  end
end
