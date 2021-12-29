require 'test_helper'

class DamagedPercentageIndicatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get damaged_percentage_indicators_index_url
    assert_response :success
  end

end
