class CreatePurchaseOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_orders do |t|
      t.references :catalog_branch, null: false, foreign_key: true
      t.date :fecha
      t.string :usuario
      t.references :catalog_area, null: false, foreign_key: true
      t.references :cost_center, null: false, foreign_key: true
      t.references :vehicle_type, null: false, foreign_key: true
      t.references :catalog_brand, null: false, foreign_key: true
      t.decimal :monto
      t.string :observaciones

      t.timestamps
    end
  end
end
