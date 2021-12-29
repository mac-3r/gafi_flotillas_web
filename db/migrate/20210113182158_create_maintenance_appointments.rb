class CreateMaintenanceAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenance_appointments do |t|
      t.date :fecha_cita
      t.integer :status
      t.references :vehicle, null: false, foreign_key: true
      t.references :catalog_workshop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
