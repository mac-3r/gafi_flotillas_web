require 'test_helper'

class DamagedVehicleIndicatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get damaged_vehicle_indicators_index_url
    assert_response :success
  end

end
