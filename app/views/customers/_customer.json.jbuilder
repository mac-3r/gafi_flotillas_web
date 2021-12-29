json.extract! customer, :id, :clave, :catalog_branch_id, :catalog_company_id, :estatus, :created_at, :updated_at
json.url customer_url(customer, format: :json)
