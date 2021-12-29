class AddColumnPurchaseOrderUserCreator < ActiveRecord::Migration[6.0]
  def change
  add_column :purchase_orders, :usuario_creador, :integer
  end
end
