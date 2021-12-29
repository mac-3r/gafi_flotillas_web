class CorrectionPurchase < ActiveRecord::Migration[6.0]
  def change
    add_reference :purchase_orders, :catalog_brand, foreign_key: true
  end
end
