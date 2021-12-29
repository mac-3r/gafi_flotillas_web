class CreateBudgetDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :budget_details do |t|
      t.references :budget_concept, null: false, foreign_key: true
      t.integer :cantidad
      t.references :catalog_brand, null: false, foreign_key: true
      t.references :reason, null: false, foreign_key: true
      t.decimal :importe
      t.decimal :plaqueo
      t.decimal :seguro

      t.timestamps
    end
  end
end
