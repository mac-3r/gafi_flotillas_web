class CreateCatalogTiresBatteries < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_tires_batteries do |t|
      t.references :catalog_brand, null: false, foreign_key: true
      t.string :medida
      t.string :modelo
      t.decimal :precio
      t.string :tipo
      t.string :moneda
      t.decimal :dls

      t.timestamps
    end
  end
end
