require "application_system_test_case"

class TuningPricesTest < ApplicationSystemTestCase
  setup do
    @tuning_price = tuning_prices(:one)
  end

  test "visiting the index" do
    visit tuning_prices_url
    assert_selector "h1", text: "Tuning Prices"
  end

  test "creating a Tuning price" do
    visit tuning_prices_url
    click_on "New Tuning Price"

    fill_in "Catalog branch", with: @tuning_price.catalog_branch_id
    fill_in "Catalog brand", with: @tuning_price.catalog_brand_id
    fill_in "Catalog workshop", with: @tuning_price.catalog_workshop_id
    fill_in "Clave", with: @tuning_price.clave
    fill_in "Precio mayor", with: @tuning_price.precio_mayor
    fill_in "Precio menor", with: @tuning_price.precio_menor
    check "Status" if @tuning_price.status
    click_on "Create Tuning price"

    assert_text "Tuning price was successfully created"
    click_on "Back"
  end

  test "updating a Tuning price" do
    visit tuning_prices_url
    click_on "Edit", match: :first

    fill_in "Catalog branch", with: @tuning_price.catalog_branch_id
    fill_in "Catalog brand", with: @tuning_price.catalog_brand_id
    fill_in "Catalog workshop", with: @tuning_price.catalog_workshop_id
    fill_in "Clave", with: @tuning_price.clave
    fill_in "Precio mayor", with: @tuning_price.precio_mayor
    fill_in "Precio menor", with: @tuning_price.precio_menor
    check "Status" if @tuning_price.status
    click_on "Update Tuning price"

    assert_text "Tuning price was successfully updated"
    click_on "Back"
  end

  test "destroying a Tuning price" do
    visit tuning_prices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tuning price was successfully destroyed"
  end
end
