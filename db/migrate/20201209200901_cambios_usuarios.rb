class CambiosUsuarios < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :catalog_role, foreign_key: true
    add_reference :users, :catalog_branch, foreign_key: true
  end
end
