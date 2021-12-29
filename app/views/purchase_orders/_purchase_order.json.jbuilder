json.extract! purchase_order, :id, :catalog_branch_id, :fecha, :usuario, :catalog_area_id, :cost_center_id, :vehicle_type_id, :vehicle_brand_id, :monto, :observaciones, :created_at, :updated_at
json.url purchase_order_url(purchase_order, format: :json)
