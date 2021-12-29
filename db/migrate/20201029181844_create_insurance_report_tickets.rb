class CreateInsuranceReportTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :insurance_report_tickets do |t|
      t.string :numero_siniestro
      t.string :inciso
      t.datetime :fecha_ocurrio
      t.datetime :fecha_reporte
      t.references :vehicle, null: false, foreign_key: true
      t.string :numero_serie
      t.string :numero_poliza
      t.string :cedis
      t.string :numero_economico
      t.string :vehiculo
      t.string :modelo
      t.string :estatus_vehiculo
      t.references :type_sinisters, null: false, foreign_key: true
      t.string :tipo_siniestro
      t.string :ubicacion_siniestro
      t.string :responsable
      t.integer :estatus
      t.float :monto_siniestro
      t.float :cargo_deducible_empresa
      t.string :cargo_deducible_empleado
      t.text :declaracion
      t.integer :estatus_responsabilidad_gafi
      t.integer :estatus_responsabilidad_aseguradora
      t.integer :coincide
      t.text :comentarios_adicionales

      t.timestamps
    end
  end
end
