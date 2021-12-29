class CreateVehicleIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_indicators do |t|
      t.references :vehicle_type, null: false, foreign_key: true
      t.boolean :activacion
      t.string :dias_habiles
      t.string :descripcion

      t.timestamps
    end
  end
end
