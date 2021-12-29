class AddColumnVehicles < ActiveRecord::Migration[6.0]
  def change
  add_column :vehicles, :ultima_verificacion, :date
  add_column :vehicles, :compra_bateria, :date
  add_column :vehicles, :recarga_extintor, :date
  add_column :vehicles, :km_cambio, :date

  end
end
