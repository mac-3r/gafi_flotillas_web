json.extract! catalog_route, :id, :clave, :descripcion, :status, :created_at, :updated_at
json.url catalog_route_url(catalog_route, format: :json)
