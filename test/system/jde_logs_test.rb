require "application_system_test_case"

class JdeLogsTest < ApplicationSystemTestCase
  setup do
    @jde_log = jde_logs(:one)
  end

  test "visiting the index" do
    visit jde_logs_url
    assert_selector "h1", text: "Jde Logs"
  end

  test "creating a Jde log" do
    visit jde_logs_url
    click_on "New Jde Log"

    fill_in "Fecha", with: @jde_log.fecha
    fill_in "Hora", with: @jde_log.hora
    fill_in "Json enviado", with: @jde_log.json_enviado
    fill_in "Respuesta", with: @jde_log.respuesta
    click_on "Create Jde log"

    assert_text "Jde log was successfully created"
    click_on "Back"
  end

  test "updating a Jde log" do
    visit jde_logs_url
    click_on "Edit", match: :first

    fill_in "Fecha", with: @jde_log.fecha
    fill_in "Hora", with: @jde_log.hora
    fill_in "Json enviado", with: @jde_log.json_enviado
    fill_in "Respuesta", with: @jde_log.respuesta
    click_on "Update Jde log"

    assert_text "Jde log was successfully updated"
    click_on "Back"
  end

  test "destroying a Jde log" do
    visit jde_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Jde log was successfully destroyed"
  end
end
