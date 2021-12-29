require 'test_helper'

class ConceptsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get concepts_index_url
    assert_response :success
  end

end
