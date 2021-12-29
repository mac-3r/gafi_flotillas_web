require 'test_helper'

class JdeLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jde_log = jde_logs(:one)
  end

  test "should get index" do
    get jde_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_jde_log_url
    assert_response :success
  end

  test "should create jde_log" do
    assert_difference('JdeLog.count') do
      post jde_logs_url, params: { jde_log: { fecha: @jde_log.fecha, hora: @jde_log.hora, json_enviado: @jde_log.json_enviado, respuesta: @jde_log.respuesta } }
    end

    assert_redirected_to jde_log_url(JdeLog.last)
  end

  test "should show jde_log" do
    get jde_log_url(@jde_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_jde_log_url(@jde_log)
    assert_response :success
  end

  test "should update jde_log" do
    patch jde_log_url(@jde_log), params: { jde_log: { fecha: @jde_log.fecha, hora: @jde_log.hora, json_enviado: @jde_log.json_enviado, respuesta: @jde_log.respuesta } }
    assert_redirected_to jde_log_url(@jde_log)
  end

  test "should destroy jde_log" do
    assert_difference('JdeLog.count', -1) do
      delete jde_log_url(@jde_log)
    end

    assert_redirected_to jde_logs_url
  end
end
