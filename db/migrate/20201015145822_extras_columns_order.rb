class ExtrasColumnsOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_orders, :cantidad, :integer 
    add_column :purchase_orders, :subtotal, :decimal 
    add_column :purchase_orders, :monto_iva, :decimal 
    add_column :purchase_orders, :total, :decimal 

  end
end
