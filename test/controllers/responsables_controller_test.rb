require 'test_helper'

class ResponsablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @responsable = responsables(:one)
  end

  test "should get index" do
    get responsables_url
    assert_response :success
  end

  test "should get new" do
    get new_responsable_url
    assert_response :success
  end

  test "should create responsable" do
    assert_difference('Responsable.count') do
      post responsables_url, params: { responsable: { nombre: @responsable.nombre, status: @responsable.status } }
    end

    assert_redirected_to responsable_url(Responsable.last)
  end

  test "should show responsable" do
    get responsable_url(@responsable)
    assert_response :success
  end

  test "should get edit" do
    get edit_responsable_url(@responsable)
    assert_response :success
  end

  test "should update responsable" do
    patch responsable_url(@responsable), params: { responsable: { nombre: @responsable.nombre, status: @responsable.status } }
    assert_redirected_to responsable_url(@responsable)
  end

  test "should destroy responsable" do
    assert_difference('Responsable.count', -1) do
      delete responsable_url(@responsable)
    end

    assert_redirected_to responsables_url
  end
end
