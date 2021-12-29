require 'test_helper'

class PolicyCoveragesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @policy_coverage = policy_coverages(:one)
  end

  test "should get index" do
    get policy_coverages_url
    assert_response :success
  end

  test "should get new" do
    get new_policy_coverage_url
    assert_response :success
  end

  test "should create policy_coverage" do
    assert_difference('PolicyCoverage.count') do
      post policy_coverages_url, params: { policy_coverage: { clave: @policy_coverage.clave, descripcion: @policy_coverage.descripcion, status: @policy_coverage.status } }
    end

    assert_redirected_to policy_coverage_url(PolicyCoverage.last)
  end

  test "should show policy_coverage" do
    get policy_coverage_url(@policy_coverage)
    assert_response :success
  end

  test "should get edit" do
    get edit_policy_coverage_url(@policy_coverage)
    assert_response :success
  end

  test "should update policy_coverage" do
    patch policy_coverage_url(@policy_coverage), params: { policy_coverage: { clave: @policy_coverage.clave, descripcion: @policy_coverage.descripcion, status: @policy_coverage.status } }
    assert_redirected_to policy_coverage_url(@policy_coverage)
  end

  test "should destroy policy_coverage" do
    assert_difference('PolicyCoverage.count', -1) do
      delete policy_coverage_url(@policy_coverage)
    end

    assert_redirected_to policy_coverages_url
  end
end
