class AddColumnBranchPurchase < ActiveRecord::Migration[6.0]
  def change
    add_reference :purchase_orders, :catalog_branch, foreign_key: true
    add_column :purchase_orders, :ultima_fecha_pago, :date
  end
end
