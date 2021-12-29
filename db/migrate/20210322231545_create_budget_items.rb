class CreateBudgetItems < ActiveRecord::Migration[6.0]
  def change
    create_table :budget_items do |t|
      t.references :catalog_branch, null: false, foreign_key: true
      t.references :catalog_area, null: false, foreign_key: true
      t.references :budget, null: false, foreign_key: true
      t.references :catalog_brand, null: false, foreign_key: true
      t.references :reason, null: false, foreign_key: true
      t.references :vehicle_type, null: false, foreign_key: true
      t.references :catalog_model, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :cantidad
      t.integer :cantidad_comprada, default: 0
      t.decimal :plaqueo, default: 0
      t.decimal :seguro, default: 0
      t.decimal :muelle, default: 0
      t.decimal :caja, default: 0
      t.decimal :rotulacion, default: 0
      t.decimal :lona, default: 0
      t.decimal :importe, default: 0

      t.timestamps
    end
  end
end
