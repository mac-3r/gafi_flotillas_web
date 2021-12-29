class CreateBinnacleOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :binnacle_orders do |t|
      t.references :service_order
      t.string :tipo_afinacion
      t.string :categoria
      t.string :concepto
      t.string :tipo_frecuencia
      t.decimal :frencuencia_reemplazo
      t.decimal :frecuencia_inspeccion
      t.string :servicio

      t.timestamps
    end
    add_column :service_orders, :km_actual, :decimal
  end
end
