class CreatePurchaseDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_details do |t|
      t.integer :cantidad
      t.references :vehicle_type, null: false, foreign_key: true
      t.references :catalog_model, null: false, foreign_key: true
      t.references :catalog_brand, null: false, foreign_key: true
      t.decimal :precio
      t.decimal :total_detalle

      t.timestamps
    end
  end
end
