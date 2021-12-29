class CreateVehicleAdaptations < ActiveRecord::Migration[6.0]
  def change
    remove_column :catalogo_adaptations, :monto
    
    create_table :vehicle_adaptations do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.decimal :monto
      t.integer :estatus
      t.references :catalogo_adaptation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
