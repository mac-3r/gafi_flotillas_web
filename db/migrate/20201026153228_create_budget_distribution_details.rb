class CreateBudgetDistributionDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :budget_distribution_details do |t|
      t.integer :cantidad
      t.references :catalog_brand, null: false, foreign_key: true
      t.references :reason, null: false, foreign_key: true
      t.decimal :plaqueo
      t.decimal :seguro
      t.decimal :muelle
      t.decimal :caja
      t.decimal :rotulacion
      t.decimal :lona
      t.decimal :importe

      t.timestamps
    end
  end
end
