require 'test_helper'

class BudgetRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get budget_requests_index_url
    assert_response :success
  end

  test "should get show" do
    get budget_requests_show_url
    assert_response :success
  end

end
