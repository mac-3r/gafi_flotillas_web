json.extract! catalog_model, :id, :clave, :descripcion, :status, :created_at, :updated_at
json.url catalog_model_url(catalog_model, format: :json)
