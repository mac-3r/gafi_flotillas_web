require 'test_helper'

class BudgetSalesReplacementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @budget_sales_replacement = budget_sales_replacements(:one)
  end

  test "should get index" do
    get budget_sales_replacements_url
    assert_response :success
  end

  test "should get new" do
    get new_budget_sales_replacement_url
    assert_response :success
  end

  test "should create budget_sales_replacement" do
    assert_difference('BudgetSalesReplacement.count') do
      post budget_sales_replacements_url, params: { budget_sales_replacement: { catalog_area_id: @budget_sales_replacement.catalog_area_id, catalog_branch_id: @budget_sales_replacement.catalog_branch_id, catalog_brand_id: @budget_sales_replacement.catalog_brand_id, fecha_compra: @budget_sales_replacement.fecha_compra, fecha_entrega: @budget_sales_replacement.fecha_entrega, importe: @budget_sales_replacement.importe, plaqueo: @budget_sales_replacement.plaqueo, reason_id: @budget_sales_replacement.reason_id, seguro: @budget_sales_replacement.seguro } }
    end

    assert_redirected_to budget_sales_replacement_url(BudgetSalesReplacement.last)
  end

  test "should show budget_sales_replacement" do
    get budget_sales_replacement_url(@budget_sales_replacement)
    assert_response :success
  end

  test "should get edit" do
    get edit_budget_sales_replacement_url(@budget_sales_replacement)
    assert_response :success
  end

  test "should update budget_sales_replacement" do
    patch budget_sales_replacement_url(@budget_sales_replacement), params: { budget_sales_replacement: { catalog_area_id: @budget_sales_replacement.catalog_area_id, catalog_branch_id: @budget_sales_replacement.catalog_branch_id, catalog_brand_id: @budget_sales_replacement.catalog_brand_id, fecha_compra: @budget_sales_replacement.fecha_compra, fecha_entrega: @budget_sales_replacement.fecha_entrega, importe: @budget_sales_replacement.importe, plaqueo: @budget_sales_replacement.plaqueo, reason_id: @budget_sales_replacement.reason_id, seguro: @budget_sales_replacement.seguro } }
    assert_redirected_to budget_sales_replacement_url(@budget_sales_replacement)
  end

  test "should destroy budget_sales_replacement" do
    assert_difference('BudgetSalesReplacement.count', -1) do
      delete budget_sales_replacement_url(@budget_sales_replacement)
    end

    assert_redirected_to budget_sales_replacements_url
  end
end
