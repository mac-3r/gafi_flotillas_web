class RemoveCustomerConsumo < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicle_consumptions, :customer_id
    add_column :vehicle_consumptions, :cliente, :string
  end
end
