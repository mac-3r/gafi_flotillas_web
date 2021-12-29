require "application_system_test_case"

class BilledCompaniesTest < ApplicationSystemTestCase
  setup do
    @billed_company = billed_companies(:one)
  end

  test "visiting the index" do
    visit billed_companies_url
    assert_selector "h1", text: "Billed Companies"
  end

  test "creating a Billed company" do
    visit billed_companies_url
    click_on "New Billed Company"

    fill_in "Clave jd", with: @billed_company.clave_jd
    fill_in "Nombre", with: @billed_company.nombre
    check "Status" if @billed_company.status
    click_on "Create Billed company"

    assert_text "Billed company was successfully created"
    click_on "Back"
  end

  test "updating a Billed company" do
    visit billed_companies_url
    click_on "Edit", match: :first

    fill_in "Clave jd", with: @billed_company.clave_jd
    fill_in "Nombre", with: @billed_company.nombre
    check "Status" if @billed_company.status
    click_on "Update Billed company"

    assert_text "Billed company was successfully updated"
    click_on "Back"
  end

  test "destroying a Billed company" do
    visit billed_companies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Billed company was successfully destroyed"
  end
end
