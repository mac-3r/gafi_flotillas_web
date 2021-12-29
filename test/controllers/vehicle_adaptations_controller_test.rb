require 'test_helper'

class VehicleAdaptationsControllerTest < ActionDispatch::IntegrationTest
  test "should get solicitar_adaptacion" do
    get vehicle_adaptations_solicitar_adaptacion_url
    assert_response :success
  end

end
