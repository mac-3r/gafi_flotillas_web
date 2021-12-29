require "application_system_test_case"

class MechanicalReviewsTest < ApplicationSystemTestCase
  setup do
    @mechanical_review = mechanical_reviews(:one)
  end

  test "visiting the index" do
    visit mechanical_reviews_url
    assert_selector "h1", text: "Mechanical Reviews"
  end

  test "creating a Mechanical review" do
    visit mechanical_reviews_url
    click_on "New Mechanical Review"

    fill_in "Catalog brand", with: @mechanical_review.catalog_brand_id
    fill_in "Clave", with: @mechanical_review.clave
    fill_in "Descripcion", with: @mechanical_review.descripcion
    check "Status" if @mechanical_review.status
    click_on "Create Mechanical review"

    assert_text "Mechanical review was successfully created"
    click_on "Back"
  end

  test "updating a Mechanical review" do
    visit mechanical_reviews_url
    click_on "Edit", match: :first

    fill_in "Catalog brand", with: @mechanical_review.catalog_brand_id
    fill_in "Clave", with: @mechanical_review.clave
    fill_in "Descripcion", with: @mechanical_review.descripcion
    check "Status" if @mechanical_review.status
    click_on "Update Mechanical review"

    assert_text "Mechanical review was successfully updated"
    click_on "Back"
  end

  test "destroying a Mechanical review" do
    visit mechanical_reviews_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mechanical review was successfully destroyed"
  end
end
