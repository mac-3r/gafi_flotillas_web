class CreateMaintenancePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenance_programs do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.decimal :km_inicio_ano
      t.decimal :km_recorrido_curso
      t.decimal :promedio_mensual
      t.decimal :frecuencia_mantenimiento
      t.date :fecha_ultima_afinacion
      t.decimal :kms_ultima_afinacion
      t.decimal :kms_proximo_servicio
      t.decimal :fecha_proximo_servicio
      t.decimal :km_actual
      t.string :observaciones

      t.timestamps
    end
  end
end
