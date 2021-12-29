require "application_system_test_case"

class CatalogPersonalsTest < ApplicationSystemTestCase
  setup do
    @catalog_personal = catalog_personals(:one)
  end

  test "visiting the index" do
    visit catalog_personals_url
    assert_selector "h1", text: "Catalog Personals"
  end

  test "creating a Catalog personal" do
    visit catalog_personals_url
    click_on "New Catalog Personal"

    fill_in "Apellido", with: @catalog_personal.apellido
    fill_in "Clave", with: @catalog_personal.clave
    fill_in "Nombre", with: @catalog_personal.nombre
    click_on "Create Catalog personal"

    assert_text "Catalog personal was successfully created"
    click_on "Back"
  end

  test "updating a Catalog personal" do
    visit catalog_personals_url
    click_on "Edit", match: :first

    fill_in "Apellido", with: @catalog_personal.apellido
    fill_in "Clave", with: @catalog_personal.clave
    fill_in "Nombre", with: @catalog_personal.nombre
    click_on "Update Catalog personal"

    assert_text "Catalog personal was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog personal" do
    visit catalog_personals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog personal was successfully destroyed"
  end
end
