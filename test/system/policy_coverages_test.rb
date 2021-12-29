require "application_system_test_case"

class PolicyCoveragesTest < ApplicationSystemTestCase
  setup do
    @policy_coverage = policy_coverages(:one)
  end

  test "visiting the index" do
    visit policy_coverages_url
    assert_selector "h1", text: "Policy Coverages"
  end

  test "creating a Policy coverage" do
    visit policy_coverages_url
    click_on "New Policy Coverage"

    fill_in "Clave", with: @policy_coverage.clave
    fill_in "Descripcion", with: @policy_coverage.descripcion
    check "Status" if @policy_coverage.status
    click_on "Create Policy coverage"

    assert_text "Policy coverage was successfully created"
    click_on "Back"
  end

  test "updating a Policy coverage" do
    visit policy_coverages_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @policy_coverage.clave
    fill_in "Descripcion", with: @policy_coverage.descripcion
    check "Status" if @policy_coverage.status
    click_on "Update Policy coverage"

    assert_text "Policy coverage was successfully updated"
    click_on "Back"
  end

  test "destroying a Policy coverage" do
    visit policy_coverages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Policy coverage was successfully destroyed"
  end
end
