require 'test_helper'

class PurchaseOrdersRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get purchase_orders_requests_index_url
    assert_response :success
  end

end
