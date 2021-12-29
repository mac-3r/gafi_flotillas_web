class CreateApproximateCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :approximate_costs do |t|
      t.decimal :mercado_libre
      t.decimal :libro_azul
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
