require "application_system_test_case"

class CatalogBranchesTest < ApplicationSystemTestCase
  setup do
    @catalog_branch = catalog_branches(:one)
  end

  test "visiting the index" do
    visit catalog_branches_url
    assert_selector "h1", text: "Catalog Branches"
  end

  test "creating a Catalog branch" do
    visit catalog_branches_url
    click_on "New Catalog Branch"

    fill_in "Catalog company", with: @catalog_branch.catalog_company_id
    fill_in "Clave", with: @catalog_branch.clave
    fill_in "Clave jd", with: @catalog_branch.clave_jd
    fill_in "Decripcion", with: @catalog_branch.decripcion
    click_on "Create Catalog branch"

    assert_text "Catalog branch was successfully created"
    click_on "Back"
  end

  test "updating a Catalog branch" do
    visit catalog_branches_url
    click_on "Edit", match: :first

    fill_in "Catalog company", with: @catalog_branch.catalog_company_id
    fill_in "Clave", with: @catalog_branch.clave
    fill_in "Clave jd", with: @catalog_branch.clave_jd
    fill_in "Decripcion", with: @catalog_branch.decripcion
    click_on "Update Catalog branch"

    assert_text "Catalog branch was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog branch" do
    visit catalog_branches_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog branch was successfully destroyed"
  end
end
