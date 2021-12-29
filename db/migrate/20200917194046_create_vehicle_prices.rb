class CreateVehiclePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_prices do |t|
      t.string :clave
      t.references :catalog_brand, null: false, foreign_key: true
      t.integer :monto
      t.boolean :status

      t.timestamps
    end
  end
end
