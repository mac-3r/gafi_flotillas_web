class AddColumnPurchaseOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_orders, :clave, :string
  end
end
