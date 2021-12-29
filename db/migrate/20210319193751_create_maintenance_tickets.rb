class CreateMaintenanceTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenance_tickets do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.string :descripcion
      t.date :fecha_alta
      t.integer :estatus

      t.timestamps
    end
  end
end
