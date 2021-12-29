require "application_system_test_case"

class PerformTargetsTest < ApplicationSystemTestCase
  setup do
    @perform_target = perform_targets(:one)
  end

  test "visiting the index" do
    visit perform_targets_url
    assert_selector "h1", text: "Perform Targets"
  end

  test "creating a Perform target" do
    visit perform_targets_url
    click_on "New Perform Target"

    fill_in "Catalog branch", with: @perform_target.catalog_branch_id
    fill_in "Clave", with: @perform_target.clave
    fill_in "Idealperform", with: @perform_target.idealperform
    fill_in "Objperform", with: @perform_target.objperform
    check "Status" if @perform_target.status
    fill_in "Vehicle type", with: @perform_target.vehicle_type_id
    click_on "Create Perform target"

    assert_text "Perform target was successfully created"
    click_on "Back"
  end

  test "updating a Perform target" do
    visit perform_targets_url
    click_on "Edit", match: :first

    fill_in "Catalog branch", with: @perform_target.catalog_branch_id
    fill_in "Clave", with: @perform_target.clave
    fill_in "Idealperform", with: @perform_target.idealperform
    fill_in "Objperform", with: @perform_target.objperform
    check "Status" if @perform_target.status
    fill_in "Vehicle type", with: @perform_target.vehicle_type_id
    click_on "Update Perform target"

    assert_text "Perform target was successfully updated"
    click_on "Back"
  end

  test "destroying a Perform target" do
    visit perform_targets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Perform target was successfully destroyed"
  end
end
