class DeleteColumnsClave < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_permits, :clave, :varchar
    remove_column :vehicle_prices, :clave, :varchar
    remove_column :catalog_responsives, :clave, :varchar
    remove_column :fuel_budgets, :clave, :varchar
    remove_column :type_sinisters, :clave, :varchar

  end
end
