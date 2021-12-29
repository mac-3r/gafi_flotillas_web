class DropTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :vehicle_models
    drop_table :vehicle_brands
  end
end
