class CamposOrdenesCompra < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_orders, :tipo, :integer
    add_column :purchase_orders, :budget_id, :integer
  end
end
