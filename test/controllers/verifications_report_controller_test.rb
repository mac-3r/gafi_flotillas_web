require 'test_helper'

class VerificationsReportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get verifications_report_index_url
    assert_response :success
  end

end
