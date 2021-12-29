class CambiosDetOrd < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_details, :plaqueo, :decimal
    add_column :purchase_details, :seguro, :decimal
    add_column :purchase_details, :muelle, :decimal
    add_column :purchase_details, :caja, :decimal
    add_column :purchase_details, :rotulacion, :decimal
    add_column :purchase_details, :lona, :decimal
    add_column :purchase_orders, :coincide_monto, :boolean
    add_column :purchase_orders, :coincide_adaptacion, :boolean
  end
end
