json.extract! vehicle_item, :id, :codigo, :vehicle_id, :tipo, :fecha_compra, :estatus, :km_inicio, :km_fin, :created_at, :updated_at
json.url vehicle_item_url(vehicle_item, format: :json)
