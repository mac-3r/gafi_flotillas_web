class CreateTuningPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :tuning_prices do |t|
      t.references :catalog_branch, null: false, foreign_key: true
      t.references :catalog_brand, null: false, foreign_key: true
      t.references :catalog_workshop, null: false, foreign_key: true
      t.decimal :precio_menor
      t.decimal :precio_mayor
      t.boolean :status
      t.string :clave

      t.timestamps
    end
  end
end
