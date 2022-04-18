require 'test_helper'

class GeneralVehicleFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get general_vehicle_files_index_url
    assert_response :success
  end

end
