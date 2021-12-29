require "application_system_test_case"

class CatalogResponsivesTest < ApplicationSystemTestCase
  setup do
    @catalog_responsife = catalog_responsives(:one)
  end

  test "visiting the index" do
    visit catalog_responsives_url
    assert_selector "h1", text: "Catalog Responsives"
  end

  test "creating a Catalog responsife" do
    visit catalog_responsives_url
    click_on "New Catalog Responsife"

    fill_in "Catalog area", with: @catalog_responsife.catalog_area_id
    fill_in "Catalog branch", with: @catalog_responsife.catalog_branch_id
    fill_in "Catalog personal", with: @catalog_responsife.catalog_personal_id
    fill_in "Clave", with: @catalog_responsife.clave
    fill_in "Correo", with: @catalog_responsife.correo
    check "Status" if @catalog_responsife.status
    click_on "Create Catalog responsife"

    assert_text "Catalog responsife was successfully created"
    click_on "Back"
  end

  test "updating a Catalog responsife" do
    visit catalog_responsives_url
    click_on "Edit", match: :first

    fill_in "Catalog area", with: @catalog_responsife.catalog_area_id
    fill_in "Catalog branch", with: @catalog_responsife.catalog_branch_id
    fill_in "Catalog personal", with: @catalog_responsife.catalog_personal_id
    fill_in "Clave", with: @catalog_responsife.clave
    fill_in "Correo", with: @catalog_responsife.correo
    check "Status" if @catalog_responsife.status
    click_on "Update Catalog responsife"

    assert_text "Catalog responsife was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog responsife" do
    visit catalog_responsives_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog responsife was successfully destroyed"
  end
end
