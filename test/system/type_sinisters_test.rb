require "application_system_test_case"

class TypeSinistersTest < ApplicationSystemTestCase
  setup do
    @type_sinister = type_sinisters(:one)
  end

  test "visiting the index" do
    visit type_sinisters_url
    assert_selector "h1", text: "Type Sinisters"
  end

  test "creating a Type sinister" do
    visit type_sinisters_url
    click_on "New Type Sinister"

    fill_in "Clave", with: @type_sinister.clave
    fill_in "Descripcion", with: @type_sinister.descripcion
    fill_in "Nombresiniestro", with: @type_sinister.nombreSiniestro
    check "Status" if @type_sinister.status
    click_on "Create Type sinister"

    assert_text "Type sinister was successfully created"
    click_on "Back"
  end

  test "updating a Type sinister" do
    visit type_sinisters_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @type_sinister.clave
    fill_in "Descripcion", with: @type_sinister.descripcion
    fill_in "Nombresiniestro", with: @type_sinister.nombreSiniestro
    check "Status" if @type_sinister.status
    click_on "Update Type sinister"

    assert_text "Type sinister was successfully updated"
    click_on "Back"
  end

  test "destroying a Type sinister" do
    visit type_sinisters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Type sinister was successfully destroyed"
  end
end
