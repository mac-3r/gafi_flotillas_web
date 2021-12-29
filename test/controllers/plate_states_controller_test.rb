require 'test_helper'

class PlateStatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plate_state = plate_states(:one)
  end

  test "should get index" do
    get plate_states_url
    assert_response :success
  end

  test "should get new" do
    get new_plate_state_url
    assert_response :success
  end

  test "should create plate_state" do
    assert_difference('PlateState.count') do
      post plate_states_url, params: { plate_state: { clave: @plate_state.clave, descripcion: @plate_state.descripcion, status: @plate_state.status } }
    end

    assert_redirected_to plate_state_url(PlateState.last)
  end

  test "should show plate_state" do
    get plate_state_url(@plate_state)
    assert_response :success
  end

  test "should get edit" do
    get edit_plate_state_url(@plate_state)
    assert_response :success
  end

  test "should update plate_state" do
    patch plate_state_url(@plate_state), params: { plate_state: { clave: @plate_state.clave, descripcion: @plate_state.descripcion, status: @plate_state.status } }
    assert_redirected_to plate_state_url(@plate_state)
  end

  test "should destroy plate_state" do
    assert_difference('PlateState.count', -1) do
      delete plate_state_url(@plate_state)
    end

    assert_redirected_to plate_states_url
  end
end
