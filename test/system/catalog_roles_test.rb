require "application_system_test_case"

class CatalogRolesTest < ApplicationSystemTestCase
  setup do
    @catalog_role = catalog_roles(:one)
  end

  test "visiting the index" do
    visit catalog_roles_url
    assert_selector "h1", text: "Catalog Roles"
  end

  test "creating a Catalog role" do
    visit catalog_roles_url
    click_on "New Catalog Role"

    fill_in "Clave", with: @catalog_role.clave
    fill_in "Descripcion", with: @catalog_role.descripcion
    fill_in "Nombre", with: @catalog_role.nombre
    check "Status" if @catalog_role.status
    click_on "Create Catalog role"

    assert_text "Catalog role was successfully created"
    click_on "Back"
  end

  test "updating a Catalog role" do
    visit catalog_roles_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @catalog_role.clave
    fill_in "Descripcion", with: @catalog_role.descripcion
    fill_in "Nombre", with: @catalog_role.nombre
    check "Status" if @catalog_role.status
    click_on "Update Catalog role"

    assert_text "Catalog role was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog role" do
    visit catalog_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog role was successfully destroyed"
  end
end
