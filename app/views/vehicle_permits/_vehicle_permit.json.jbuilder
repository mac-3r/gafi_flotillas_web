json.extract! vehicle_permit, :id, :clave, :descripcion, :status, :created_at, :updated_at
json.url vehicle_permit_url(vehicle_permit, format: :json)
