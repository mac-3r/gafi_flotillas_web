class CreateBudgetSalesReplacements < ActiveRecord::Migration[6.0]
  def change
    create_table :budget_sales_replacements do |t|
      t.references :catalog_branch, null: false, foreign_key: true
      t.date :fecha_entrega
      t.references :catalog_area, null: false, foreign_key: true
      t.references :catalog_brand, null: false, foreign_key: true
      t.decimal :importe
      t.references :reason, null: false, foreign_key: true
      t.date :fecha_compra
      t.decimal :plaqueo
      t.decimal :seguro

      t.timestamps
    end
  end
end
