class CreateJoinPermissionRol < ActiveRecord::Migration[6.0]
  def change
    create_join_table :permissions, :catalog_roles do |t|
      t.index [:permission_id, :catalog_role_id], name: "permisos_rols"
      t.index [:catalog_role_id, :permission_id], name: "rols_permisos"
    end
  end
end
