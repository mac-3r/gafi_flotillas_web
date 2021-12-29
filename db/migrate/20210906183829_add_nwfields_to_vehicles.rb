class AddNwfieldsToVehicles < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :permiso_sat, :string
    add_column :vehicles, :numero_permiso, :string
    add_column :vehicles, :numero_aseguradora, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
