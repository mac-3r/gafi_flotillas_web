require 'test_helper'

class ResponsibleIncidentReportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get responsible_incident_report_index_url
    assert_response :success
  end

end
