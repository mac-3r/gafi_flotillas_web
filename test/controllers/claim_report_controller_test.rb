require 'test_helper'

class ClaimReportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get claim_report_index_url
    assert_response :success
  end

end
