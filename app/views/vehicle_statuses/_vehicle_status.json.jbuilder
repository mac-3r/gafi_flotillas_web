json.extract! vehicle_status, :id, :nombre, :descripcion, :status, :created_at, :updated_at
json.url vehicle_status_url(vehicle_status, format: :json)
