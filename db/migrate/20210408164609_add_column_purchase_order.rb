class AddColumnPurchaseOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_orders, :fecha_factura, :date
    add_column :purchase_orders, :uuid, :string
    add_column :purchase_orders, :numero_factura, :string
    add_column :purchase_orders, :impuestos, :decimal
  end
end
