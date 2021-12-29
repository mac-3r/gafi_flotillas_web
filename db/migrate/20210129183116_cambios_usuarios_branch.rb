class CambiosUsuariosBranch < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :catalog_branch_id
    create_join_table :catalog_branches, :users do |t|
      t.index [:catalog_branch_id, :user_id]
      t.index [:user_id, :catalog_branch_id]
    end
  end
end
