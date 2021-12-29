class CreateVehicleConsumptions < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_consumptions do |t|
      t.references :vehicle
      t.integer :tarjeta
      t.string :placa
      t.references :catalog_brand
      t.references :catalog_area
      t.string :estacion
      t.date :fecha
      t.time :hora
      t.integer :despacho
      t.integer :bomba
      t.string :producto
      t.float :cantidad
      t.float :monto
      t.references :customer
      t.string :datos
      t.references :responsable
      t.integer :odometro
      t.float :rendimiento
      t.float :recorrido
      t.date :fecha_inicio
      t.date :fecha_fin

      t.timestamps
    end
  end
end
