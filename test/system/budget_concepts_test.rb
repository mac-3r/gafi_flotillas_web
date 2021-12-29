require "application_system_test_case"

class BudgetConceptsTest < ApplicationSystemTestCase
  setup do
    @budget_concept = budget_concepts(:one)
  end

  test "visiting the index" do
    visit budget_concepts_url
    assert_selector "h1", text: "Budget Concepts"
  end

  test "creating a Budget concept" do
    visit budget_concepts_url
    click_on "New Budget Concept"

    fill_in "Clave", with: @budget_concept.clave
    fill_in "Descripcion", with: @budget_concept.descripcion
    check "Status" if @budget_concept.status
    click_on "Create Budget concept"

    assert_text "Budget concept was successfully created"
    click_on "Back"
  end

  test "updating a Budget concept" do
    visit budget_concepts_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @budget_concept.clave
    fill_in "Descripcion", with: @budget_concept.descripcion
    check "Status" if @budget_concept.status
    click_on "Update Budget concept"

    assert_text "Budget concept was successfully updated"
    click_on "Back"
  end

  test "destroying a Budget concept" do
    visit budget_concepts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Budget concept was successfully destroyed"
  end
end
