class CreateServiceOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :service_orders do |t|
      t.string :n_orden
      t.integer :estatus
      t.string :descripcion
      t.datetime :fecha_entrada
      t.datetime :fecha_salida
      t.references :maintenance_program, null: false, foreign_key: true
      t.references :maintenance_appointment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
