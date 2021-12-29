class CambiosVehicleConsumption < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_consumptions, :catalog_brand_id
    remove_column :vehicle_consumptions, :catalog_area_id
    remove_column :vehicle_consumptions, :responsable_id

  end
end
