require 'test_helper'

class MonthlyYieldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monthly_yield = monthly_yields(:one)
  end

  test "should get index" do
    get monthly_yields_url
    assert_response :success
  end

  test "should get new" do
    get new_monthly_yield_url
    assert_response :success
  end

  test "should create monthly_yield" do
    assert_difference('MonthlyYield.count') do
      post monthly_yields_url, params: { monthly_yield: { catalog_branch_id: @monthly_yield.catalog_branch_id, catalog_brand_id: @monthly_yield.catalog_brand_id, catalog_model_id: @monthly_yield.catalog_model_id, cierre_abril: @monthly_yield.cierre_abril, cierre_agosto: @monthly_yield.cierre_agosto, cierre_diciembre: @monthly_yield.cierre_diciembre, cierre_enero: @monthly_yield.cierre_enero, cierre_febrero: @monthly_yield.cierre_febrero, cierre_julio: @monthly_yield.cierre_julio, cierre_junio: @monthly_yield.cierre_junio, cierre_marzo: @monthly_yield.cierre_marzo, cierre_mayo: @monthly_yield.cierre_mayo, cierre_noviembre: @monthly_yield.cierre_noviembre, cierre_octubre: @monthly_yield.cierre_octubre, cierre_septiembre: @monthly_yield.cierre_septiembre, lts_abril: @monthly_yield.lts_abril, lts_agosto: @monthly_yield.lts_agosto, lts_diciembre: @monthly_yield.lts_diciembre, lts_enero: @monthly_yield.lts_enero, lts_febrero: @monthly_yield.lts_febrero, lts_julio: @monthly_yield.lts_julio, lts_junio: @monthly_yield.lts_junio, lts_marzo: @monthly_yield.lts_marzo, lts_mayo: @monthly_yield.lts_mayo, lts_noviembre: @monthly_yield.lts_noviembre, lts_octubre: @monthly_yield.lts_octubre, lts_septiembre: @monthly_yield.lts_septiembre, recorrido_abril: @monthly_yield.recorrido_abril, recorrido_agosto: @monthly_yield.recorrido_agosto, recorrido_diciembre: @monthly_yield.recorrido_diciembre, recorrido_enero: @monthly_yield.recorrido_enero, recorrido_febrero: @monthly_yield.recorrido_febrero, recorrido_julio: @monthly_yield.recorrido_julio, recorrido_junio: @monthly_yield.recorrido_junio, recorrido_marzo: @monthly_yield.recorrido_marzo, recorrido_mayo: @monthly_yield.recorrido_mayo, recorrido_noviembre: @monthly_yield.recorrido_noviembre, recorrido_octubre: @monthly_yield.recorrido_octubre, recorrido_septiembre: @monthly_yield.recorrido_septiembre, rendi_abril: @monthly_yield.rendi_abril, rendi_agosto: @monthly_yield.rendi_agosto, rendi_diciembre: @monthly_yield.rendi_diciembre, rendi_enero: @monthly_yield.rendi_enero, rendi_febrero: @monthly_yield.rendi_febrero, rendi_julio: @monthly_yield.rendi_julio, rendi_junio: @monthly_yield.rendi_junio, rendi_marzo: @monthly_yield.rendi_marzo, rendi_mayo: @monthly_yield.rendi_mayo, rendi_noviembre: @monthly_yield.rendi_noviembre, rendi_octubre: @monthly_yield.rendi_octubre, rendi_septiembre: @monthly_yield.rendi_septiembre, vehicle_id: @monthly_yield.vehicle_id, vehicle_type_id: @monthly_yield.vehicle_type_id } }
    end

    assert_redirected_to monthly_yield_url(MonthlyYield.last)
  end

  test "should show monthly_yield" do
    get monthly_yield_url(@monthly_yield)
    assert_response :success
  end

  test "should get edit" do
    get edit_monthly_yield_url(@monthly_yield)
    assert_response :success
  end

  test "should update monthly_yield" do
    patch monthly_yield_url(@monthly_yield), params: { monthly_yield: { catalog_branch_id: @monthly_yield.catalog_branch_id, catalog_brand_id: @monthly_yield.catalog_brand_id, catalog_model_id: @monthly_yield.catalog_model_id, cierre_abril: @monthly_yield.cierre_abril, cierre_agosto: @monthly_yield.cierre_agosto, cierre_diciembre: @monthly_yield.cierre_diciembre, cierre_enero: @monthly_yield.cierre_enero, cierre_febrero: @monthly_yield.cierre_febrero, cierre_julio: @monthly_yield.cierre_julio, cierre_junio: @monthly_yield.cierre_junio, cierre_marzo: @monthly_yield.cierre_marzo, cierre_mayo: @monthly_yield.cierre_mayo, cierre_noviembre: @monthly_yield.cierre_noviembre, cierre_octubre: @monthly_yield.cierre_octubre, cierre_septiembre: @monthly_yield.cierre_septiembre, lts_abril: @monthly_yield.lts_abril, lts_agosto: @monthly_yield.lts_agosto, lts_diciembre: @monthly_yield.lts_diciembre, lts_enero: @monthly_yield.lts_enero, lts_febrero: @monthly_yield.lts_febrero, lts_julio: @monthly_yield.lts_julio, lts_junio: @monthly_yield.lts_junio, lts_marzo: @monthly_yield.lts_marzo, lts_mayo: @monthly_yield.lts_mayo, lts_noviembre: @monthly_yield.lts_noviembre, lts_octubre: @monthly_yield.lts_octubre, lts_septiembre: @monthly_yield.lts_septiembre, recorrido_abril: @monthly_yield.recorrido_abril, recorrido_agosto: @monthly_yield.recorrido_agosto, recorrido_diciembre: @monthly_yield.recorrido_diciembre, recorrido_enero: @monthly_yield.recorrido_enero, recorrido_febrero: @monthly_yield.recorrido_febrero, recorrido_julio: @monthly_yield.recorrido_julio, recorrido_junio: @monthly_yield.recorrido_junio, recorrido_marzo: @monthly_yield.recorrido_marzo, recorrido_mayo: @monthly_yield.recorrido_mayo, recorrido_noviembre: @monthly_yield.recorrido_noviembre, recorrido_octubre: @monthly_yield.recorrido_octubre, recorrido_septiembre: @monthly_yield.recorrido_septiembre, rendi_abril: @monthly_yield.rendi_abril, rendi_agosto: @monthly_yield.rendi_agosto, rendi_diciembre: @monthly_yield.rendi_diciembre, rendi_enero: @monthly_yield.rendi_enero, rendi_febrero: @monthly_yield.rendi_febrero, rendi_julio: @monthly_yield.rendi_julio, rendi_junio: @monthly_yield.rendi_junio, rendi_marzo: @monthly_yield.rendi_marzo, rendi_mayo: @monthly_yield.rendi_mayo, rendi_noviembre: @monthly_yield.rendi_noviembre, rendi_octubre: @monthly_yield.rendi_octubre, rendi_septiembre: @monthly_yield.rendi_septiembre, vehicle_id: @monthly_yield.vehicle_id, vehicle_type_id: @monthly_yield.vehicle_type_id } }
    assert_redirected_to monthly_yield_url(@monthly_yield)
  end

  test "should destroy monthly_yield" do
    assert_difference('MonthlyYield.count', -1) do
      delete monthly_yield_url(@monthly_yield)
    end

    assert_redirected_to monthly_yields_url
  end
end
