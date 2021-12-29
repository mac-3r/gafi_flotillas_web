require "application_system_test_case"

class MonthlyYieldsTest < ApplicationSystemTestCase
  setup do
    @monthly_yield = monthly_yields(:one)
  end

  test "visiting the index" do
    visit monthly_yields_url
    assert_selector "h1", text: "Monthly Yields"
  end

  test "creating a Monthly yield" do
    visit monthly_yields_url
    click_on "New Monthly Yield"

    fill_in "Catalog branch", with: @monthly_yield.catalog_branch_id
    fill_in "Catalog brand", with: @monthly_yield.catalog_brand_id
    fill_in "Catalog model", with: @monthly_yield.catalog_model_id
    fill_in "Cierre abril", with: @monthly_yield.cierre_abril
    fill_in "Cierre agosto", with: @monthly_yield.cierre_agosto
    fill_in "Cierre diciembre", with: @monthly_yield.cierre_diciembre
    fill_in "Cierre enero", with: @monthly_yield.cierre_enero
    fill_in "Cierre febrero", with: @monthly_yield.cierre_febrero
    fill_in "Cierre julio", with: @monthly_yield.cierre_julio
    fill_in "Cierre junio", with: @monthly_yield.cierre_junio
    fill_in "Cierre marzo", with: @monthly_yield.cierre_marzo
    fill_in "Cierre mayo", with: @monthly_yield.cierre_mayo
    fill_in "Cierre noviembre", with: @monthly_yield.cierre_noviembre
    fill_in "Cierre octubre", with: @monthly_yield.cierre_octubre
    fill_in "Cierre septiembre", with: @monthly_yield.cierre_septiembre
    fill_in "Lts abril", with: @monthly_yield.lts_abril
    fill_in "Lts agosto", with: @monthly_yield.lts_agosto
    fill_in "Lts diciembre", with: @monthly_yield.lts_diciembre
    fill_in "Lts enero", with: @monthly_yield.lts_enero
    fill_in "Lts febrero", with: @monthly_yield.lts_febrero
    fill_in "Lts julio", with: @monthly_yield.lts_julio
    fill_in "Lts junio", with: @monthly_yield.lts_junio
    fill_in "Lts marzo", with: @monthly_yield.lts_marzo
    fill_in "Lts mayo", with: @monthly_yield.lts_mayo
    fill_in "Lts noviembre", with: @monthly_yield.lts_noviembre
    fill_in "Lts octubre", with: @monthly_yield.lts_octubre
    fill_in "Lts septiembre", with: @monthly_yield.lts_septiembre
    fill_in "Recorrido abril", with: @monthly_yield.recorrido_abril
    fill_in "Recorrido agosto", with: @monthly_yield.recorrido_agosto
    fill_in "Recorrido diciembre", with: @monthly_yield.recorrido_diciembre
    fill_in "Recorrido enero", with: @monthly_yield.recorrido_enero
    fill_in "Recorrido febrero", with: @monthly_yield.recorrido_febrero
    fill_in "Recorrido julio", with: @monthly_yield.recorrido_julio
    fill_in "Recorrido junio", with: @monthly_yield.recorrido_junio
    fill_in "Recorrido marzo", with: @monthly_yield.recorrido_marzo
    fill_in "Recorrido mayo", with: @monthly_yield.recorrido_mayo
    fill_in "Recorrido noviembre", with: @monthly_yield.recorrido_noviembre
    fill_in "Recorrido octubre", with: @monthly_yield.recorrido_octubre
    fill_in "Recorrido septiembre", with: @monthly_yield.recorrido_septiembre
    fill_in "Rendi abril", with: @monthly_yield.rendi_abril
    fill_in "Rendi agosto", with: @monthly_yield.rendi_agosto
    fill_in "Rendi diciembre", with: @monthly_yield.rendi_diciembre
    fill_in "Rendi enero", with: @monthly_yield.rendi_enero
    fill_in "Rendi febrero", with: @monthly_yield.rendi_febrero
    fill_in "Rendi julio", with: @monthly_yield.rendi_julio
    fill_in "Rendi junio", with: @monthly_yield.rendi_junio
    fill_in "Rendi marzo", with: @monthly_yield.rendi_marzo
    fill_in "Rendi mayo", with: @monthly_yield.rendi_mayo
    fill_in "Rendi noviembre", with: @monthly_yield.rendi_noviembre
    fill_in "Rendi octubre", with: @monthly_yield.rendi_octubre
    fill_in "Rendi septiembre", with: @monthly_yield.rendi_septiembre
    fill_in "Vehicle", with: @monthly_yield.vehicle_id
    fill_in "Vehicle type", with: @monthly_yield.vehicle_type_id
    click_on "Create Monthly yield"

    assert_text "Monthly yield was successfully created"
    click_on "Back"
  end

  test "updating a Monthly yield" do
    visit monthly_yields_url
    click_on "Edit", match: :first

    fill_in "Catalog branch", with: @monthly_yield.catalog_branch_id
    fill_in "Catalog brand", with: @monthly_yield.catalog_brand_id
    fill_in "Catalog model", with: @monthly_yield.catalog_model_id
    fill_in "Cierre abril", with: @monthly_yield.cierre_abril
    fill_in "Cierre agosto", with: @monthly_yield.cierre_agosto
    fill_in "Cierre diciembre", with: @monthly_yield.cierre_diciembre
    fill_in "Cierre enero", with: @monthly_yield.cierre_enero
    fill_in "Cierre febrero", with: @monthly_yield.cierre_febrero
    fill_in "Cierre julio", with: @monthly_yield.cierre_julio
    fill_in "Cierre junio", with: @monthly_yield.cierre_junio
    fill_in "Cierre marzo", with: @monthly_yield.cierre_marzo
    fill_in "Cierre mayo", with: @monthly_yield.cierre_mayo
    fill_in "Cierre noviembre", with: @monthly_yield.cierre_noviembre
    fill_in "Cierre octubre", with: @monthly_yield.cierre_octubre
    fill_in "Cierre septiembre", with: @monthly_yield.cierre_septiembre
    fill_in "Lts abril", with: @monthly_yield.lts_abril
    fill_in "Lts agosto", with: @monthly_yield.lts_agosto
    fill_in "Lts diciembre", with: @monthly_yield.lts_diciembre
    fill_in "Lts enero", with: @monthly_yield.lts_enero
    fill_in "Lts febrero", with: @monthly_yield.lts_febrero
    fill_in "Lts julio", with: @monthly_yield.lts_julio
    fill_in "Lts junio", with: @monthly_yield.lts_junio
    fill_in "Lts marzo", with: @monthly_yield.lts_marzo
    fill_in "Lts mayo", with: @monthly_yield.lts_mayo
    fill_in "Lts noviembre", with: @monthly_yield.lts_noviembre
    fill_in "Lts octubre", with: @monthly_yield.lts_octubre
    fill_in "Lts septiembre", with: @monthly_yield.lts_septiembre
    fill_in "Recorrido abril", with: @monthly_yield.recorrido_abril
    fill_in "Recorrido agosto", with: @monthly_yield.recorrido_agosto
    fill_in "Recorrido diciembre", with: @monthly_yield.recorrido_diciembre
    fill_in "Recorrido enero", with: @monthly_yield.recorrido_enero
    fill_in "Recorrido febrero", with: @monthly_yield.recorrido_febrero
    fill_in "Recorrido julio", with: @monthly_yield.recorrido_julio
    fill_in "Recorrido junio", with: @monthly_yield.recorrido_junio
    fill_in "Recorrido marzo", with: @monthly_yield.recorrido_marzo
    fill_in "Recorrido mayo", with: @monthly_yield.recorrido_mayo
    fill_in "Recorrido noviembre", with: @monthly_yield.recorrido_noviembre
    fill_in "Recorrido octubre", with: @monthly_yield.recorrido_octubre
    fill_in "Recorrido septiembre", with: @monthly_yield.recorrido_septiembre
    fill_in "Rendi abril", with: @monthly_yield.rendi_abril
    fill_in "Rendi agosto", with: @monthly_yield.rendi_agosto
    fill_in "Rendi diciembre", with: @monthly_yield.rendi_diciembre
    fill_in "Rendi enero", with: @monthly_yield.rendi_enero
    fill_in "Rendi febrero", with: @monthly_yield.rendi_febrero
    fill_in "Rendi julio", with: @monthly_yield.rendi_julio
    fill_in "Rendi junio", with: @monthly_yield.rendi_junio
    fill_in "Rendi marzo", with: @monthly_yield.rendi_marzo
    fill_in "Rendi mayo", with: @monthly_yield.rendi_mayo
    fill_in "Rendi noviembre", with: @monthly_yield.rendi_noviembre
    fill_in "Rendi octubre", with: @monthly_yield.rendi_octubre
    fill_in "Rendi septiembre", with: @monthly_yield.rendi_septiembre
    fill_in "Vehicle", with: @monthly_yield.vehicle_id
    fill_in "Vehicle type", with: @monthly_yield.vehicle_type_id
    click_on "Update Monthly yield"

    assert_text "Monthly yield was successfully updated"
    click_on "Back"
  end

  test "destroying a Monthly yield" do
    visit monthly_yields_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Monthly yield was successfully destroyed"
  end
end
