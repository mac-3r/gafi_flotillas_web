class IndexCompetencia < ActiveRecord::Migration[6.0]
  def change
    add_index :competition_tables, [:catalog_branch_id, :catalog_role_id], :unique => true,name: 'index_role_branch'

  end
end
