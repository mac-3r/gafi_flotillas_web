class AddFieldsToVehiclepolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_policies, :modelo_vehiculo, :string
    add_column :vehicle_policies, :anio, :string
    add_column :vehicle_policies, :asignado, :boolean, default: false
    add_column :vehicle_policies, :estatus, :boolean, default: true
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
