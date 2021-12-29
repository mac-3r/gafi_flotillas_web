class CampoOrdenCompra < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_orders, :plazo_dias, :integer
    remove_column :purchase_orders, :vehicle_type_id
    remove_column :purchase_orders, :catalog_model_id
    remove_column :purchase_orders, :catalog_brand_id
    remove_column :purchase_orders, :cantidad
    remove_column :purchase_orders, :monto
    
  end
end
