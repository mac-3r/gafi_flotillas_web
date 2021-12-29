require 'test_helper'

class InsurancePoliciesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get insurance_policies_index_url
    assert_response :success
  end

end
