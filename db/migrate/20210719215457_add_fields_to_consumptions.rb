class AddFieldsToConsumptions < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicle_consumptions, :catalog_area
  end
end
