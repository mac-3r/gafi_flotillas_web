require "application_system_test_case"

class CatalogoAdaptationsTest < ApplicationSystemTestCase
  setup do
    @catalogo_adaptation = catalogo_adaptations(:one)
  end

  test "visiting the index" do
    visit catalogo_adaptations_url
    assert_selector "h1", text: "Catalogo Adaptations"
  end

  test "creating a Catalogo adaptation" do
    visit catalogo_adaptations_url
    click_on "New Catalogo Adaptation"

    fill_in "Clave", with: @catalogo_adaptation.clave
    fill_in "Descripcion", with: @catalogo_adaptation.descripcion
    check "Status" if @catalogo_adaptation.status
    click_on "Create Catalogo adaptation"

    assert_text "Catalogo adaptation was successfully created"
    click_on "Back"
  end

  test "updating a Catalogo adaptation" do
    visit catalogo_adaptations_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @catalogo_adaptation.clave
    fill_in "Descripcion", with: @catalogo_adaptation.descripcion
    check "Status" if @catalogo_adaptation.status
    click_on "Update Catalogo adaptation"

    assert_text "Catalogo adaptation was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalogo adaptation" do
    visit catalogo_adaptations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalogo adaptation was successfully destroyed"
  end
end
