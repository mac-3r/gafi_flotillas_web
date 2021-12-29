json.extract! catalog_workshop, :id, :clave, :catalog_branch_id, :nombre_taller, :razonsocial, :especialidad, :responsable, :telefono, :domicilio, :correo, :vigente, :created_at, :updated_at
json.url catalog_workshop_url(catalog_workshop, format: :json)
