require "application_system_test_case"

class ConceptServicesTest < ApplicationSystemTestCase
  setup do
    @concept_service = concept_services(:one)
  end

  test "visiting the index" do
    visit concept_services_url
    assert_selector "h1", text: "Concept Services"
  end

  test "creating a Concept service" do
    visit concept_services_url
    click_on "New Concept Service"

    click_on "Create Concept service"

    assert_text "Concept service was successfully created"
    click_on "Back"
  end

  test "updating a Concept service" do
    visit concept_services_url
    click_on "Edit", match: :first

    click_on "Update Concept service"

    assert_text "Concept service was successfully updated"
    click_on "Back"
  end

  test "destroying a Concept service" do
    visit concept_services_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Concept service was successfully destroyed"
  end
end
