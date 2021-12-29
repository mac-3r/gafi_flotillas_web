class CorrectionPurchaseOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :purchase_orders, :catalog_brand_id

  end
end
