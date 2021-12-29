class Addvehiclescorrections < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicles, :clave, :varchar
    remove_column :vehicles, :status, :boolean
    add_reference :vehicles, :vehicle_permit, foreign_key: true
    #change_column(:vehicles, :numero_economico, :varchar)
  end
end
