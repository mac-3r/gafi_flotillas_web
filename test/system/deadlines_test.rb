require "application_system_test_case"

class DeadlinesTest < ApplicationSystemTestCase
  setup do
    @deadline = deadlines(:one)
  end

  test "visiting the index" do
    visit deadlines_url
    assert_selector "h1", text: "Deadlines"
  end

  test "creating a Deadline" do
    visit deadlines_url
    click_on "New Deadline"

    click_on "Create Deadline"

    assert_text "Deadline was successfully created"
    click_on "Back"
  end

  test "updating a Deadline" do
    visit deadlines_url
    click_on "Edit", match: :first

    click_on "Update Deadline"

    assert_text "Deadline was successfully updated"
    click_on "Back"
  end

  test "destroying a Deadline" do
    visit deadlines_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Deadline was successfully destroyed"
  end
end
