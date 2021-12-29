class IndexCompetencias < ActiveRecord::Migration[6.0]
  def change
    remove_index :competition_tables, name: "index_role_branch"

    add_index :competition_tables, [:catalog_branch_id, :catalog_role_id,:tipo], :unique => true,name: 'index_role_branch_type'

  end
end
