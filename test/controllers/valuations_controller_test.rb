require 'test_helper'

class ValuationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get valuations_index_url
    assert_response :success
  end

  test "should get create" do
    get valuations_create_url
    assert_response :success
  end

  test "should get update" do
    get valuations_update_url
    assert_response :success
  end

  test "should get destroy" do
    get valuations_destroy_url
    assert_response :success
  end

  test "should get modal_crear" do
    get valuations_modal_crear_url
    assert_response :success
  end

  test "should get modal_editar" do
    get valuations_modal_editar_url
    assert_response :success
  end

end
