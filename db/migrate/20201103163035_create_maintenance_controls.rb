class CreateMaintenanceControls < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenance_controls do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :catalog_branch, null: false, foreign_key: true
      t.string :mes_pago
      t.references :catalog_workshop, null: false, foreign_key: true
      t.references :catalog_repair, null: false, foreign_key: true
      t.string :observaciones
      t.date :fecha_factura
      t.string :año
      t.decimal :importe
      t.decimal :importe_iva
      t.string :ciudad
      t.references :catalog_area, null: false, foreign_key: true
      t.references :responsable, null: false, foreign_key: true

      t.timestamps
    end
  end
end
