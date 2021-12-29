class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.date :fecha_inicial
      t.decimal :precio_inicial
      t.date :fecha_venta
      t.decimal :precio_final
      t.references :vehicle, null: false, foreign_key: true
      t.timestamps
    end
  end
end
