class CreateVehicleItems < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_items do |t|
      t.string :codigo
      t.string :string
      t.references :vehicle, null: false, foreign_key: true
      t.integer :tipo
      t.string :fecha_compra
      t.string :date
      t.integer :estatus
      t.decimal :km_inicio
      t.decimal :km_fin

      t.timestamps
    end
  end
end
