require 'test_helper'

class BudgetDistributionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @budget_distribution = budget_distributions(:one)
  end

  test "should get index" do
    get budget_distributions_url
    assert_response :success
  end

  test "should get new" do
    get new_budget_distribution_url
    assert_response :success
  end

  test "should create budget_distribution" do
    assert_difference('BudgetDistribution.count') do
      post budget_distributions_url, params: { budget_distribution: { caja: @budget_distribution.caja, catalog_area_id: @budget_distribution.catalog_area_id, catalog_branch_id: @budget_distribution.catalog_branch_id, catalog_brand_id: @budget_distribution.catalog_brand_id, fecha_compra: @budget_distribution.fecha_compra, fecha_entrega: @budget_distribution.fecha_entrega, importe: @budget_distribution.importe, muelles: @budget_distribution.muelles, plaqueo: @budget_distribution.plaqueo, reason_id: @budget_distribution.reason_id, rotulacion: @budget_distribution.rotulacion, seguro: @budget_distribution.seguro } }
    end

    assert_redirected_to budget_distribution_url(BudgetDistribution.last)
  end

  test "should show budget_distribution" do
    get budget_distribution_url(@budget_distribution)
    assert_response :success
  end

  test "should get edit" do
    get edit_budget_distribution_url(@budget_distribution)
    assert_response :success
  end

  test "should update budget_distribution" do
    patch budget_distribution_url(@budget_distribution), params: { budget_distribution: { caja: @budget_distribution.caja, catalog_area_id: @budget_distribution.catalog_area_id, catalog_branch_id: @budget_distribution.catalog_branch_id, catalog_brand_id: @budget_distribution.catalog_brand_id, fecha_compra: @budget_distribution.fecha_compra, fecha_entrega: @budget_distribution.fecha_entrega, importe: @budget_distribution.importe, muelles: @budget_distribution.muelles, plaqueo: @budget_distribution.plaqueo, reason_id: @budget_distribution.reason_id, rotulacion: @budget_distribution.rotulacion, seguro: @budget_distribution.seguro } }
    assert_redirected_to budget_distribution_url(@budget_distribution)
  end

  test "should destroy budget_distribution" do
    assert_difference('BudgetDistribution.count', -1) do
      delete budget_distribution_url(@budget_distribution)
    end

    assert_redirected_to budget_distributions_url
  end
end
