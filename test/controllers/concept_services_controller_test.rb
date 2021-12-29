require 'test_helper'

class ConceptServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @concept_service = concept_services(:one)
  end

  test "should get index" do
    get concept_services_url
    assert_response :success
  end

  test "should get new" do
    get new_concept_service_url
    assert_response :success
  end

  test "should create concept_service" do
    assert_difference('ConceptService.count') do
      post concept_services_url, params: { concept_service: {  } }
    end

    assert_redirected_to concept_service_url(ConceptService.last)
  end

  test "should show concept_service" do
    get concept_service_url(@concept_service)
    assert_response :success
  end

  test "should get edit" do
    get edit_concept_service_url(@concept_service)
    assert_response :success
  end

  test "should update concept_service" do
    patch concept_service_url(@concept_service), params: { concept_service: {  } }
    assert_redirected_to concept_service_url(@concept_service)
  end

  test "should destroy concept_service" do
    assert_difference('ConceptService.count', -1) do
      delete concept_service_url(@concept_service)
    end

    assert_redirected_to concept_services_url
  end
end
