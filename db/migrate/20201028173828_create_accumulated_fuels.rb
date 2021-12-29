class CreateAccumulatedFuels < ActiveRecord::Migration[6.0]
  def change
    create_table :accumulated_fuels do |t|
      t.string :no_economico
      t.string :cedis
      t.string :tipo_vehicu
      t.string :linea
      t.string :area
      t.string :responsable
      t.date :fecha_carga
      t.date :fecha_inicio
      t.date :fecha_fin
      t.string :n_factura
      t.float :litros_consumidos
      t.float :importe_base
      t.float :importe_total
      t.float :km_inicial
      t.float :km_actual
      t.float :gasto
      t.float :km_recorrido
      t.string :presupuesto

      t.timestamps
    end
  end
end
