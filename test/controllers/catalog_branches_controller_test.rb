require 'test_helper'

class CatalogBranchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_branch = catalog_branches(:one)
  end

  test "should get index" do
    get catalog_branches_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_branch_url
    assert_response :success
  end

  test "should create catalog_branch" do
    assert_difference('CatalogBranch.count') do
      post catalog_branches_url, params: { catalog_branch: { catalog_company_id: @catalog_branch.catalog_company_id, clave: @catalog_branch.clave, clave_jd: @catalog_branch.clave_jd, decripcion: @catalog_branch.decripcion } }
    end

    assert_redirected_to catalog_branch_url(CatalogBranch.last)
  end

  test "should show catalog_branch" do
    get catalog_branch_url(@catalog_branch)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_branch_url(@catalog_branch)
    assert_response :success
  end

  test "should update catalog_branch" do
    patch catalog_branch_url(@catalog_branch), params: { catalog_branch: { catalog_company_id: @catalog_branch.catalog_company_id, clave: @catalog_branch.clave, clave_jd: @catalog_branch.clave_jd, decripcion: @catalog_branch.decripcion } }
    assert_redirected_to catalog_branch_url(@catalog_branch)
  end

  test "should destroy catalog_branch" do
    assert_difference('CatalogBranch.count', -1) do
      delete catalog_branch_url(@catalog_branch)
    end

    assert_redirected_to catalog_branches_url
  end
end
