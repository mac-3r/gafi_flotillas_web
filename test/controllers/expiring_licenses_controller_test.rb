require 'test_helper'

class ExpiringLicensesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get expiring_licenses_index_url
    assert_response :success
  end

end
