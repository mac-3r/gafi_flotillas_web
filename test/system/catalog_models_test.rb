require "application_system_test_case"

class CatalogModelsTest < ApplicationSystemTestCase
  setup do
    @catalog_model = catalog_models(:one)
  end

  test "visiting the index" do
    visit catalog_models_url
    assert_selector "h1", text: "Catalog Models"
  end

  test "creating a Catalog model" do
    visit catalog_models_url
    click_on "New Catalog Model"

    fill_in "Clave", with: @catalog_model.clave
    fill_in "Descripcion", with: @catalog_model.descripcion
    check "Status" if @catalog_model.status
    click_on "Create Catalog model"

    assert_text "Catalog model was successfully created"
    click_on "Back"
  end

  test "updating a Catalog model" do
    visit catalog_models_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @catalog_model.clave
    fill_in "Descripcion", with: @catalog_model.descripcion
    check "Status" if @catalog_model.status
    click_on "Update Catalog model"

    assert_text "Catalog model was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog model" do
    visit catalog_models_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog model was successfully destroyed"
  end
end
