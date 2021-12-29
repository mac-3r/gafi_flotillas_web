class ChangeTypeNumer < ActiveRecord::Migration[6.0]
  def change
    change_column :vehicles, :numero_economico, :varchar
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
