require 'test_helper'

class FuelBudgetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fuel_budget = fuel_budgets(:one)
  end

  test "should get index" do
    get fuel_budgets_url
    assert_response :success
  end

  test "should get new" do
    get new_fuel_budget_url
    assert_response :success
  end

  test "should create fuel_budget" do
    assert_difference('FuelBudget.count') do
      post fuel_budgets_url, params: { fuel_budget: { clave: @fuel_budget.clave, descripcion: @fuel_budget.descripcion, precio_litro: @fuel_budget.precio_litro } }
    end

    assert_redirected_to fuel_budget_url(FuelBudget.last)
  end

  test "should show fuel_budget" do
    get fuel_budget_url(@fuel_budget)
    assert_response :success
  end

  test "should get edit" do
    get edit_fuel_budget_url(@fuel_budget)
    assert_response :success
  end

  test "should update fuel_budget" do
    patch fuel_budget_url(@fuel_budget), params: { fuel_budget: { clave: @fuel_budget.clave, descripcion: @fuel_budget.descripcion, precio_litro: @fuel_budget.precio_litro } }
    assert_redirected_to fuel_budget_url(@fuel_budget)
  end

  test "should destroy fuel_budget" do
    assert_difference('FuelBudget.count', -1) do
      delete fuel_budget_url(@fuel_budget)
    end

    assert_redirected_to fuel_budgets_url
  end
end
