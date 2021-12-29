require "application_system_test_case"

class WorkshopCertificationsTest < ApplicationSystemTestCase
  setup do
    @workshop_certification = workshop_certifications(:one)
  end

  test "visiting the index" do
    visit workshop_certifications_url
    assert_selector "h1", text: "Workshop Certifications"
  end

  test "creating a Workshop certification" do
    visit workshop_certifications_url
    click_on "New Workshop Certification"

    fill_in "Catalog workshop", with: @workshop_certification.catalog_workshop_id
    fill_in "Condiciones", with: @workshop_certification.condiciones
    fill_in "Estatus", with: @workshop_certification.estatus
    fill_in "Fecha", with: @workshop_certification.fecha
    fill_in "Numero ticket", with: @workshop_certification.numero_ticket
    click_on "Create Workshop certification"

    assert_text "Workshop certification was successfully created"
    click_on "Back"
  end

  test "updating a Workshop certification" do
    visit workshop_certifications_url
    click_on "Edit", match: :first

    fill_in "Catalog workshop", with: @workshop_certification.catalog_workshop_id
    fill_in "Condiciones", with: @workshop_certification.condiciones
    fill_in "Estatus", with: @workshop_certification.estatus
    fill_in "Fecha", with: @workshop_certification.fecha
    fill_in "Numero ticket", with: @workshop_certification.numero_ticket
    click_on "Update Workshop certification"

    assert_text "Workshop certification was successfully updated"
    click_on "Back"
  end

  test "destroying a Workshop certification" do
    visit workshop_certifications_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Workshop certification was successfully destroyed"
  end
end
