require 'test_helper'

class TypeSinistersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @type_sinister = type_sinisters(:one)
  end

  test "should get index" do
    get type_sinisters_url
    assert_response :success
  end

  test "should get new" do
    get new_type_sinister_url
    assert_response :success
  end

  test "should create type_sinister" do
    assert_difference('TypeSinister.count') do
      post type_sinisters_url, params: { type_sinister: { clave: @type_sinister.clave, descripcion: @type_sinister.descripcion, nombreSiniestro: @type_sinister.nombreSiniestro, status: @type_sinister.status } }
    end

    assert_redirected_to type_sinister_url(TypeSinister.last)
  end

  test "should show type_sinister" do
    get type_sinister_url(@type_sinister)
    assert_response :success
  end

  test "should get edit" do
    get edit_type_sinister_url(@type_sinister)
    assert_response :success
  end

  test "should update type_sinister" do
    patch type_sinister_url(@type_sinister), params: { type_sinister: { clave: @type_sinister.clave, descripcion: @type_sinister.descripcion, nombreSiniestro: @type_sinister.nombreSiniestro, status: @type_sinister.status } }
    assert_redirected_to type_sinister_url(@type_sinister)
  end

  test "should destroy type_sinister" do
    assert_difference('TypeSinister.count', -1) do
      delete type_sinister_url(@type_sinister)
    end

    assert_redirected_to type_sinisters_url
  end
end
