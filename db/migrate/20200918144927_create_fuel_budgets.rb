class CreateFuelBudgets < ActiveRecord::Migration[6.0]
  def change
    create_table :fuel_budgets do |t|
      t.string :clave
      t.string :descripcion
      t.decimal :precio_litro

      t.timestamps
    end
  end
end
