class CreateConsumptions < ActiveRecord::Migration[6.0]
  def change
    create_table :consumptions do |t|
      t.integer :folio
      t.date :fecha_inicio
      t.date :fecha_fin
      t.integer :cargas
      t.string :factura
      t.float :monto
      t.integer :estatus

      t.timestamps
    end
  end
end
