require 'test_helper'

class CatalogBranchesUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get catalog_branches_users_index_url
    assert_response :success
  end

end
