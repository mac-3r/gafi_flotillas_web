json.extract! maintenance_ticket, :id, :vehicle_id, :descripcion, :fecha_alta, :estatus, :created_at, :updated_at
json.url maintenance_ticket_url(maintenance_ticket, format: :json)
