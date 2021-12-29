class ErrorOrden < ActiveRecord::Migration[6.0]
  def change
    remove_column :purchase_orders, :catalog_branch_id
    add_reference :purchase_orders, :catalog_company, foreign_key: true
  end
end
