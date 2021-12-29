require 'test_helper'

class MechanicalReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mechanical_review = mechanical_reviews(:one)
  end

  test "should get index" do
    get mechanical_reviews_url
    assert_response :success
  end

  test "should get new" do
    get new_mechanical_review_url
    assert_response :success
  end

  test "should create mechanical_review" do
    assert_difference('MechanicalReview.count') do
      post mechanical_reviews_url, params: { mechanical_review: { catalog_brand_id: @mechanical_review.catalog_brand_id, clave: @mechanical_review.clave, descripcion: @mechanical_review.descripcion, status: @mechanical_review.status } }
    end

    assert_redirected_to mechanical_review_url(MechanicalReview.last)
  end

  test "should show mechanical_review" do
    get mechanical_review_url(@mechanical_review)
    assert_response :success
  end

  test "should get edit" do
    get edit_mechanical_review_url(@mechanical_review)
    assert_response :success
  end

  test "should update mechanical_review" do
    patch mechanical_review_url(@mechanical_review), params: { mechanical_review: { catalog_brand_id: @mechanical_review.catalog_brand_id, clave: @mechanical_review.clave, descripcion: @mechanical_review.descripcion, status: @mechanical_review.status } }
    assert_redirected_to mechanical_review_url(@mechanical_review)
  end

  test "should destroy mechanical_review" do
    assert_difference('MechanicalReview.count', -1) do
      delete mechanical_review_url(@mechanical_review)
    end

    assert_redirected_to mechanical_reviews_url
  end
end
