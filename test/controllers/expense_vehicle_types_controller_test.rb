require 'test_helper'

class ExpenseVehicleTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expense_vehicle_type = expense_vehicle_types(:one)
  end

  test "should get index" do
    get expense_vehicle_types_url
    assert_response :success
  end

  test "should get new" do
    get new_expense_vehicle_type_url
    assert_response :success
  end

  test "should create expense_vehicle_type" do
    assert_difference('ExpenseVehicleType.count') do
      post expense_vehicle_types_url, params: { expense_vehicle_type: { catalog_branch_id: @expense_vehicle_type.catalog_branch_id, catalog_brand_id: @expense_vehicle_type.catalog_brand_id, clave: @expense_vehicle_type.clave, gasto: @expense_vehicle_type.gasto } }
    end

    assert_redirected_to expense_vehicle_type_url(ExpenseVehicleType.last)
  end

  test "should show expense_vehicle_type" do
    get expense_vehicle_type_url(@expense_vehicle_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_expense_vehicle_type_url(@expense_vehicle_type)
    assert_response :success
  end

  test "should update expense_vehicle_type" do
    patch expense_vehicle_type_url(@expense_vehicle_type), params: { expense_vehicle_type: { catalog_branch_id: @expense_vehicle_type.catalog_branch_id, catalog_brand_id: @expense_vehicle_type.catalog_brand_id, clave: @expense_vehicle_type.clave, gasto: @expense_vehicle_type.gasto } }
    assert_redirected_to expense_vehicle_type_url(@expense_vehicle_type)
  end

  test "should destroy expense_vehicle_type" do
    assert_difference('ExpenseVehicleType.count', -1) do
      delete expense_vehicle_type_url(@expense_vehicle_type)
    end

    assert_redirected_to expense_vehicle_types_url
  end
end
