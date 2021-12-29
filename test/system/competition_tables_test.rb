require "application_system_test_case"

class CompetitionTablesTest < ApplicationSystemTestCase
  setup do
    @competition_table = competition_tables(:one)
  end

  test "visiting the index" do
    visit competition_tables_url
    assert_selector "h1", text: "Competition Tables"
  end

  test "creating a Competition table" do
    visit competition_tables_url
    click_on "New Competition Table"

    fill_in "Catalog branch", with: @competition_table.catalog_branch_id
    fill_in "Direccion", with: @competition_table.direccion
    fill_in "Gerencia corporativa", with: @competition_table.gerencia_corporativa
    fill_in "Gerencia operaciones", with: @competition_table.gerencia_operaciones
    click_on "Create Competition table"

    assert_text "Competition table was successfully created"
    click_on "Back"
  end

  test "updating a Competition table" do
    visit competition_tables_url
    click_on "Edit", match: :first

    fill_in "Catalog branch", with: @competition_table.catalog_branch_id
    fill_in "Direccion", with: @competition_table.direccion
    fill_in "Gerencia corporativa", with: @competition_table.gerencia_corporativa
    fill_in "Gerencia operaciones", with: @competition_table.gerencia_operaciones
    click_on "Update Competition table"

    assert_text "Competition table was successfully updated"
    click_on "Back"
  end

  test "destroying a Competition table" do
    visit competition_tables_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Competition table was successfully destroyed"
  end
end
