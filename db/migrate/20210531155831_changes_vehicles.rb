class ChangesVehicles < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :reparto, :boolean
    add_reference :purchase_orders, :user, foreign_key: true, null:true
  end
end
