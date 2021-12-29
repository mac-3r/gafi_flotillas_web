require "application_system_test_case"

class ReviewWorkshopsTest < ApplicationSystemTestCase
  setup do
    @review_workshop = review_workshops(:one)
  end

  test "visiting the index" do
    visit review_workshops_url
    assert_selector "h1", text: "Review Workshops"
  end

  test "creating a Review workshop" do
    visit review_workshops_url
    click_on "New Review Workshop"

    fill_in "Clave", with: @review_workshop.clave
    fill_in "Descripcion", with: @review_workshop.descripcion
    check "Status" if @review_workshop.status
    click_on "Create Review workshop"

    assert_text "Review workshop was successfully created"
    click_on "Back"
  end

  test "updating a Review workshop" do
    visit review_workshops_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @review_workshop.clave
    fill_in "Descripcion", with: @review_workshop.descripcion
    check "Status" if @review_workshop.status
    click_on "Update Review workshop"

    assert_text "Review workshop was successfully updated"
    click_on "Back"
  end

  test "destroying a Review workshop" do
    visit review_workshops_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Review workshop was successfully destroyed"
  end
end
