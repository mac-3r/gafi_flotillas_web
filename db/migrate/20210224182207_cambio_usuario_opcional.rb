class CambioUsuarioOpcional < ActiveRecord::Migration[6.0]
  def change
    change_column :catalog_vendors, :user_id, :integer, null:true
    change_column :catalog_personals, :user_id, :integer, null:true
    change_column :responsables, :catalog_personal_id, :integer, null:true
  end
end
