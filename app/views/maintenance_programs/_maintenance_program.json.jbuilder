json.extract! maintenance_program, :id, :vehicle_id, :km_inicio_ano, :km_recorrido_curso, :promedio_mensual, :frecuencia_mantenimiento, :fecha_ultima_afinacion, :kms_ultima_afinacion, :kms_proximo_servicio, :fecha_proximo_servicio, :km_actual, :observaciones, :created_at, :updated_at
json.url maintenance_program_url(maintenance_program, format: :json)
