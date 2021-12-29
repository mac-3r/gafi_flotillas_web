json.extract! user_vehicle, :id, :user_id, :vehicle_id, :created_at, :updated_at
json.url user_vehicle_url(user_vehicle, format: :json)
