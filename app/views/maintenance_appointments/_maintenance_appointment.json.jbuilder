json.extract! maintenance_appointment, :id, :fecha_cita, :status, :vehicle_id, :catalog_workshop_id, :created_at, :updated_at
json.url maintenance_appointment_url(maintenance_appointment, format: :json)
