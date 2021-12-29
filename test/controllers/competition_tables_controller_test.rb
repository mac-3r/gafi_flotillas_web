require 'test_helper'

class CompetitionTablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @competition_table = competition_tables(:one)
  end

  test "should get index" do
    get competition_tables_url
    assert_response :success
  end

  test "should get new" do
    get new_competition_table_url
    assert_response :success
  end

  test "should create competition_table" do
    assert_difference('CompetitionTable.count') do
      post competition_tables_url, params: { competition_table: { catalog_branch_id: @competition_table.catalog_branch_id, direccion: @competition_table.direccion, gerencia_corporativa: @competition_table.gerencia_corporativa, gerencia_operaciones: @competition_table.gerencia_operaciones } }
    end

    assert_redirected_to competition_table_url(CompetitionTable.last)
  end

  test "should show competition_table" do
    get competition_table_url(@competition_table)
    assert_response :success
  end

  test "should get edit" do
    get edit_competition_table_url(@competition_table)
    assert_response :success
  end

  test "should update competition_table" do
    patch competition_table_url(@competition_table), params: { competition_table: { catalog_branch_id: @competition_table.catalog_branch_id, direccion: @competition_table.direccion, gerencia_corporativa: @competition_table.gerencia_corporativa, gerencia_operaciones: @competition_table.gerencia_operaciones } }
    assert_redirected_to competition_table_url(@competition_table)
  end

  test "should destroy competition_table" do
    assert_difference('CompetitionTable.count', -1) do
      delete competition_table_url(@competition_table)
    end

    assert_redirected_to competition_tables_url
  end
end
