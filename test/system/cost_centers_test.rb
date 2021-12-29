require "application_system_test_case"

class CostCentersTest < ApplicationSystemTestCase
  setup do
    @cost_center = cost_centers(:one)
  end

  test "visiting the index" do
    visit cost_centers_url
    assert_selector "h1", text: "Cost Centers"
  end

  test "creating a Cost center" do
    visit cost_centers_url
    click_on "New Cost Center"

    fill_in "Clave", with: @cost_center.clave
    fill_in "Descripcion", with: @cost_center.descripcion
    check "Status" if @cost_center.status
    click_on "Create Cost center"

    assert_text "Cost center was successfully created"
    click_on "Back"
  end

  test "updating a Cost center" do
    visit cost_centers_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @cost_center.clave
    fill_in "Descripcion", with: @cost_center.descripcion
    check "Status" if @cost_center.status
    click_on "Update Cost center"

    assert_text "Cost center was successfully updated"
    click_on "Back"
  end

  test "destroying a Cost center" do
    visit cost_centers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cost center was successfully destroyed"
  end
end
