class ChangeColumnInVehiclePrices < ActiveRecord::Migration[6.0]
  def change
    change_column(:vehicle_prices, :monto, :decimal)
  end
end
