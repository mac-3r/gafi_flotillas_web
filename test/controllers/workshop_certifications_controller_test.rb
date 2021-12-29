require 'test_helper'

class WorkshopCertificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @workshop_certification = workshop_certifications(:one)
  end

  test "should get index" do
    get workshop_certifications_url
    assert_response :success
  end

  test "should get new" do
    get new_workshop_certification_url
    assert_response :success
  end

  test "should create workshop_certification" do
    assert_difference('WorkshopCertification.count') do
      post workshop_certifications_url, params: { workshop_certification: { catalog_workshop_id: @workshop_certification.catalog_workshop_id, condiciones: @workshop_certification.condiciones, estatus: @workshop_certification.estatus, fecha: @workshop_certification.fecha, numero_ticket: @workshop_certification.numero_ticket } }
    end

    assert_redirected_to workshop_certification_url(WorkshopCertification.last)
  end

  test "should show workshop_certification" do
    get workshop_certification_url(@workshop_certification)
    assert_response :success
  end

  test "should get edit" do
    get edit_workshop_certification_url(@workshop_certification)
    assert_response :success
  end

  test "should update workshop_certification" do
    patch workshop_certification_url(@workshop_certification), params: { workshop_certification: { catalog_workshop_id: @workshop_certification.catalog_workshop_id, condiciones: @workshop_certification.condiciones, estatus: @workshop_certification.estatus, fecha: @workshop_certification.fecha, numero_ticket: @workshop_certification.numero_ticket } }
    assert_redirected_to workshop_certification_url(@workshop_certification)
  end

  test "should destroy workshop_certification" do
    assert_difference('WorkshopCertification.count', -1) do
      delete workshop_certification_url(@workshop_certification)
    end

    assert_redirected_to workshop_certifications_url
  end
end
