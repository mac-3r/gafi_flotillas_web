json.extract! service_order, :id, :n_orden, :estatus, :descripcion, :fecha_entrada, :fecha_salida, :maintenance_program_id, :maintenance_appointment_id, :created_at, :updated_at
json.url service_order_url(service_order, format: :json)
