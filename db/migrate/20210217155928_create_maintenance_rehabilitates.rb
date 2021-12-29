class CreateMaintenanceRehabilitates < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenance_rehabilitates do |t|
      t.string :reparacion
      t.decimal :costo
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
