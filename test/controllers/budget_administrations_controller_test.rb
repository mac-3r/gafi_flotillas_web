require 'test_helper'

class BudgetAdministrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @budget_administration = budget_administrations(:one)
  end

  test "should get index" do
    get budget_administrations_url
    assert_response :success
  end

  test "should get new" do
    get new_budget_administration_url
    assert_response :success
  end

  test "should create budget_administration" do
    assert_difference('BudgetAdministration.count') do
      post budget_administrations_url, params: { budget_administration: { catalog_area_id: @budget_administration.catalog_area_id, catalog_branch_id: @budget_administration.catalog_branch_id, clave: @budget_administration.clave, fecha_compra: @budget_administration.fecha_compra, fecha_entrega: @budget_administration.fecha_entrega } }
    end

    assert_redirected_to budget_administration_url(BudgetAdministration.last)
  end

  test "should show budget_administration" do
    get budget_administration_url(@budget_administration)
    assert_response :success
  end

  test "should get edit" do
    get edit_budget_administration_url(@budget_administration)
    assert_response :success
  end

  test "should update budget_administration" do
    patch budget_administration_url(@budget_administration), params: { budget_administration: { catalog_area_id: @budget_administration.catalog_area_id, catalog_branch_id: @budget_administration.catalog_branch_id, clave: @budget_administration.clave, fecha_compra: @budget_administration.fecha_compra, fecha_entrega: @budget_administration.fecha_entrega } }
    assert_redirected_to budget_administration_url(@budget_administration)
  end

  test "should destroy budget_administration" do
    assert_difference('BudgetAdministration.count', -1) do
      delete budget_administration_url(@budget_administration)
    end

    assert_redirected_to budget_administrations_url
  end
end
