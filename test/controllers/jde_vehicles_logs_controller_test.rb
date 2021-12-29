require 'test_helper'

class JdeVehiclesLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jde_vehicles_logs_index_url
    assert_response :success
  end

end
