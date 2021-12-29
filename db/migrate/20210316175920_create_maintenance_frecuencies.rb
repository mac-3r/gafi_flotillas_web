class CreateMaintenanceFrecuencies < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenance_frecuencies do |t|
      t.decimal :mensual_recorrido
      t.decimal :frecuencia
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
