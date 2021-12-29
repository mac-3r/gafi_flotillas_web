require 'test_helper'

class DamagedVehicleAmmountIndicatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get damaged_vehicle_ammount_indicators_index_url
    assert_response :success
  end

end
