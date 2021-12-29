require 'test_helper'

class BudgetDeliveryReplacementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @budget_delivery_replacement = budget_delivery_replacements(:one)
  end

  test "should get index" do
    get budget_delivery_replacements_url
    assert_response :success
  end

  test "should get new" do
    get new_budget_delivery_replacement_url
    assert_response :success
  end

  test "should create budget_delivery_replacement" do
    assert_difference('BudgetDeliveryReplacement.count') do
      post budget_delivery_replacements_url, params: { budget_delivery_replacement: { caja: @budget_delivery_replacement.caja, catalog_area_id: @budget_delivery_replacement.catalog_area_id, catalog_branch_id: @budget_delivery_replacement.catalog_branch_id, catalog_brand_id: @budget_delivery_replacement.catalog_brand_id, fecha_compra: @budget_delivery_replacement.fecha_compra, fecha_entrega: @budget_delivery_replacement.fecha_entrega, importe: @budget_delivery_replacement.importe, muelle: @budget_delivery_replacement.muelle, plaqueo: @budget_delivery_replacement.plaqueo, reason_id: @budget_delivery_replacement.reason_id, rotulacion: @budget_delivery_replacement.rotulacion, seguro: @budget_delivery_replacement.seguro } }
    end

    assert_redirected_to budget_delivery_replacement_url(BudgetDeliveryReplacement.last)
  end

  test "should show budget_delivery_replacement" do
    get budget_delivery_replacement_url(@budget_delivery_replacement)
    assert_response :success
  end

  test "should get edit" do
    get edit_budget_delivery_replacement_url(@budget_delivery_replacement)
    assert_response :success
  end

  test "should update budget_delivery_replacement" do
    patch budget_delivery_replacement_url(@budget_delivery_replacement), params: { budget_delivery_replacement: { caja: @budget_delivery_replacement.caja, catalog_area_id: @budget_delivery_replacement.catalog_area_id, catalog_branch_id: @budget_delivery_replacement.catalog_branch_id, catalog_brand_id: @budget_delivery_replacement.catalog_brand_id, fecha_compra: @budget_delivery_replacement.fecha_compra, fecha_entrega: @budget_delivery_replacement.fecha_entrega, importe: @budget_delivery_replacement.importe, muelle: @budget_delivery_replacement.muelle, plaqueo: @budget_delivery_replacement.plaqueo, reason_id: @budget_delivery_replacement.reason_id, rotulacion: @budget_delivery_replacement.rotulacion, seguro: @budget_delivery_replacement.seguro } }
    assert_redirected_to budget_delivery_replacement_url(@budget_delivery_replacement)
  end

  test "should destroy budget_delivery_replacement" do
    assert_difference('BudgetDeliveryReplacement.count', -1) do
      delete budget_delivery_replacement_url(@budget_delivery_replacement)
    end

    assert_redirected_to budget_delivery_replacements_url
  end
end
