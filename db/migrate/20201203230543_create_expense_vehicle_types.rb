class CreateExpenseVehicleTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_vehicle_types do |t|
      t.references :catalog_branch, null: false, foreign_key: true
      t.references :catalog_brand, null: false, foreign_key: true
      t.decimal :gasto
      t.string :clave

      t.timestamps
    end
  end
end
