class CreateJoinTableRolUser < ActiveRecord::Migration[6.0]
  def change
    create_join_table :catalog_roles, :users do |t|
      t.index [:catalog_role_id, :user_id]
      t.index [:user_id, :catalog_role_id]
    end
  end
end
