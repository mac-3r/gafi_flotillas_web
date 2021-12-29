class Addcolumnorderservices < ActiveRecord::Migration[6.0]
  def change
    add_reference :service_orders, :catalog_tires_battery, foreign_key: true, null:true
    add_column :tuning_prices, :anio, :integer
    add_column :tuning_prices, :precio_mayor_sin, :decimal
  end
end
