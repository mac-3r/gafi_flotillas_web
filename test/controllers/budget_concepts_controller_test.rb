require 'test_helper'

class BudgetConceptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @budget_concept = budget_concepts(:one)
  end

  test "should get index" do
    get budget_concepts_url
    assert_response :success
  end

  test "should get new" do
    get new_budget_concept_url
    assert_response :success
  end

  test "should create budget_concept" do
    assert_difference('BudgetConcept.count') do
      post budget_concepts_url, params: { budget_concept: { clave: @budget_concept.clave, descripcion: @budget_concept.descripcion, status: @budget_concept.status } }
    end

    assert_redirected_to budget_concept_url(BudgetConcept.last)
  end

  test "should show budget_concept" do
    get budget_concept_url(@budget_concept)
    assert_response :success
  end

  test "should get edit" do
    get edit_budget_concept_url(@budget_concept)
    assert_response :success
  end

  test "should update budget_concept" do
    patch budget_concept_url(@budget_concept), params: { budget_concept: { clave: @budget_concept.clave, descripcion: @budget_concept.descripcion, status: @budget_concept.status } }
    assert_redirected_to budget_concept_url(@budget_concept)
  end

  test "should destroy budget_concept" do
    assert_difference('BudgetConcept.count', -1) do
      delete budget_concept_url(@budget_concept)
    end

    assert_redirected_to budget_concepts_url
  end
end
