require 'test_helper'

class ReviewWorkshopsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review_workshop = review_workshops(:one)
  end

  test "should get index" do
    get review_workshops_url
    assert_response :success
  end

  test "should get new" do
    get new_review_workshop_url
    assert_response :success
  end

  test "should create review_workshop" do
    assert_difference('ReviewWorkshop.count') do
      post review_workshops_url, params: { review_workshop: { clave: @review_workshop.clave, descripcion: @review_workshop.descripcion, status: @review_workshop.status } }
    end

    assert_redirected_to review_workshop_url(ReviewWorkshop.last)
  end

  test "should show review_workshop" do
    get review_workshop_url(@review_workshop)
    assert_response :success
  end

  test "should get edit" do
    get edit_review_workshop_url(@review_workshop)
    assert_response :success
  end

  test "should update review_workshop" do
    patch review_workshop_url(@review_workshop), params: { review_workshop: { clave: @review_workshop.clave, descripcion: @review_workshop.descripcion, status: @review_workshop.status } }
    assert_redirected_to review_workshop_url(@review_workshop)
  end

  test "should destroy review_workshop" do
    assert_difference('ReviewWorkshop.count', -1) do
      delete review_workshop_url(@review_workshop)
    end

    assert_redirected_to review_workshops_url
  end
end
