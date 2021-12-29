class RemoveForeignConsumo < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_consumptions, :vehicle_id
    remove_column :vehicle_consumptions, :catalog_brand_id
    remove_column :vehicle_consumptions, :catalog_area_id
    remove_column :vehicle_consumptions, :responsable_id
    add_column :vehicle_consumptions, :no_economico, :integer
    add_column :vehicle_consumptions, :desc_linea, :string
    add_column :vehicle_consumptions, :grupo, :string
    add_column :vehicle_consumptions, :responsable, :string
  end
end
